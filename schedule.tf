/* escalation policy */
resource "pagerduty_escalation_policy" "ep" {
  name = "API Escalation Policy"
  rule {
    escalation_delay_in_minutes = 30
    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.foo.id
    }
  }
}

/* ADD YOUR EMAIL TO THIS BLOCK */
data "pagerduty_user" "me" {
  email = "kevinkhalafi@gmail.com"
}

/* SCHEDULE */
resource "pagerduty_schedule" "foo" {
  name      = "API Schedule"
  time_zone = "America/Los_Angeles"

  layer {
    name                         = "Day Shift"
    start                        = "2021-05-05T20:00:00Z"
    rotation_virtual_start       = "2020-05-05T08:00:00Z"
    rotation_turn_length_seconds = 86400
    users                        = [data.pagerduty_user.me.id]

    restriction {
      type              = "daily_restriction"
      start_time_of_day = "08:00:00"
      duration_seconds  = 32400
    }
  }
  layer {
    name                         = "Night Shift"
    start                        = "2021-05-05T20:00:00Z"
    rotation_virtual_start       = "2020-05-05T17:00:00Z"
    rotation_turn_length_seconds = 86400
    users                        = [pagerduty_user.lisa.id, pagerduty_user.bart.id]

    restriction {
      type              = "daily_restriction"
      start_time_of_day = "17:00:00"
      duration_seconds  = 54000
    }
  }
}

