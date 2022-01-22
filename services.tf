/* SERVICES */
resource "pagerduty_service" "api" {
  name              = "Checkout API"
  escalation_policy = pagerduty_escalation_policy.ep.id
  alert_creation    = "create_alerts_and_incidents"
}

resource "pagerduty_service" "db" {
  name              = "Checkout DB"
  escalation_policy = pagerduty_escalation_policy.ep.id
  alert_creation    = "create_alerts_and_incidents"
}

/* SERVICE INTEGRATION */
data "pagerduty_vendor" "cloudwatch" {
  name = "Cloudwatch"
}

resource "pagerduty_service_integration" "cloudwatch" {
  name    = data.pagerduty_vendor.cloudwatch.name
  service = pagerduty_service.api.id
  vendor  = data.pagerduty_vendor.cloudwatch.id
}

data "pagerduty_vendor" "datadog" {
  name = "Datadog"
}

resource "pagerduty_service_integration" "datadog" {
  name    =  data.pagerduty_vendor.datadog.name
  service = pagerduty_service.api.id
  vendor  = data.pagerduty_vendor.datadog.id
}

/* BUSINESS SERVICE */
resource "pagerduty_business_service" "api-business" {
  name = "API Business"
}

/* SERVICE DEPENDENCY */
resource "pagerduty_service_dependency" "api-service-dependency" {
  dependency {
    dependent_service {
      id   = pagerduty_business_service.api-business.id
      type = "business_service"
    }
    supporting_service {
      id   = pagerduty_service.api.id
      type = "service"
    }
  }
}
resource "pagerduty_service_dependency" "api-db-service-dependency" {
  dependency {
    dependent_service {
      id   = pagerduty_business_service.api-business.id
      type = "business_service"
    }
    supporting_service {
      id   = pagerduty_service.db.id
      type = "service"
    }
  }
}