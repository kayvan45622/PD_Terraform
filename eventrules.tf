/* RULESET */
resource "pagerduty_ruleset" "api-service" {
  name = "API Ruleset"
  team {
    id = pagerduty_team.simpson.id
  }
}

/* RULESET RULES (EVENT RULES) */
resource "pagerduty_ruleset_rule" "health-check" {
  ruleset  = pagerduty_ruleset.api-service.id
  position = 0
  disabled = false
  conditions {
    operator = "and"
    subconditions {
      operator = "contains"
      parameter {
        value = "API Health Check violated API Request Failure"
        path  = "payload.summary"
      }
    }
  }
  actions {
    suppress {
      value                 = true
      threshold_value       = 3
      threshold_time_unit   = "minutes"
      threshold_time_amount = 10
    }
    route {
      value = pagerduty_service.api.id
    }
  }
}

resource "pagerduty_ruleset_rule" "db-connection" {
  ruleset  = pagerduty_ruleset.api-service.id
  position = 1
  disabled = false
  conditions {
    operator = "and"
    subconditions {
      operator = "contains"
      parameter {
        value = "Error connecting to MySQL"
        path  = "payload.summary"
      }
    }
  }
  actions {
    route {
      value = pagerduty_service.db.id
    }
  }
}

resource "pagerduty_ruleset_rule" "high-request-time" {
  ruleset  = pagerduty_ruleset.api-service.id
  position = 2
  disabled = false
  conditions {
    operator = "and"
    subconditions {
      operator = "contains"
      parameter {
        value = "Request Response Time is High for prod"
        path  = "payload.summary"
      }
    }
  }
  actions {
    route {
      value = pagerduty_service.api.id
    }
    route {
      value = pagerduty_service.api.id
    }
    annotate {
      value = "Refer to runbook at response.pagerduty.com"
    }
  }
}

resource "pagerduty_ruleset_rule" "mysql-long-running-query" {
  ruleset  = pagerduty_ruleset.api-service.id
  position = 3
  disabled = false
  conditions {
    operator = "and"
    subconditions {
      operator = "contains"
      parameter {
        value = "mysql_long_running_query"
        path  = "payload.summary"
      }
    }
  }
  actions {
    route {
      value = pagerduty_service.db.id
    }
    severity {
      value = "info"
    }
  }
}