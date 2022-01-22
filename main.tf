provider "pagerduty" {
  token = "u+C7L1eV4hxAG36tKPyg"
}
terraform {
    required_providers {
        pagerduty = {
            source = "PagerDuty/pagerduty"
            version = "2.2.1"
        }
    }
}
resource "pagerduty_user" "bart" {
  email       = "bart@simpson.com"
  name        = "Bart J Simpson"
  role        = "limited_user"
  description = "Spikey-haired boy"
  job_title   = "Rascal"
}

resource "pagerduty_user" "lisa" {
  email       = "lisa@simpson.com"
  name        = "Lisa Simpson"
  role        = "admin"
  description = "The brains"
  job_title   = "Supreme Thinker"
}


# /* TEAMS */
resource "pagerduty_team" "simpson" {
  name        = "Simpson"
  description = "Team of Simpsons"
}


/* TEAM MEMBERSHIP */
resource "pagerduty_team_membership" "lisa-member" {
  user_id = pagerduty_user.lisa.id
  team_id = pagerduty_team.simpson.id
  role    = "manager"
}

resource "pagerduty_team_membership" "bart-member" {
  user_id = pagerduty_user.bart.id
  team_id = pagerduty_team.simpson.id
  role    = "responder"
}

# EOF

/* Test */
