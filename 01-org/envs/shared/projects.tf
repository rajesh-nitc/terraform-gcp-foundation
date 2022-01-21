/******************************************
  Projects for log sinks
*****************************************/

module "org_audit_logs" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 11.1"
  random_project_id       = "true"
  default_service_account = "deprivilege"
  name                    = "${var.project_prefix}-c-logging"
  org_id                  = var.org_id
  billing_account         = var.billing_account
  folder_id               = google_folder.common.id
  activate_apis = [
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "billingbudgets.googleapis.com",
    "iamcredentials.googleapis.com",
  ]

  labels = {
    environment       = "production"
    application_name  = "org-logging"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "abcd"
    env_code          = "p"
  }
  budget_alert_pubsub_topic   = var.org_audit_logs_project_alert_pubsub_topic
  budget_alert_spent_percents = var.org_audit_logs_project_alert_spent_percents
  budget_amount               = var.org_audit_logs_project_budget_amount
}

/******************************************
  Project for DNS Hub
*****************************************/

module "dns_hub" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 11.1"
  random_project_id       = "true"
  default_service_account = "deprivilege"
  name                    = "${var.project_prefix}-c-dns-hub"
  org_id                  = var.org_id
  billing_account         = var.billing_account
  folder_id               = google_folder.common.id

  activate_apis = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "servicenetworking.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "billingbudgets.googleapis.com",
    "iamcredentials.googleapis.com"
  ]

  labels = {
    environment       = "production"
    application_name  = "org-dns-hub"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "abcd"
    env_code          = "p"
  }
  budget_alert_pubsub_topic   = var.dns_hub_project_alert_pubsub_topic
  budget_alert_spent_percents = var.dns_hub_project_alert_spent_percents
  budget_amount               = var.dns_hub_project_budget_amount
}

/******************************************
  Project for Base Network Hub
*****************************************/

module "base_network_hub" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 11.1"
  count                   = var.enable_hub_and_spoke ? 1 : 0
  random_project_id       = "true"
  default_service_account = "deprivilege"
  name                    = "${var.project_prefix}-c-base-net-hub"
  org_id                  = var.org_id
  billing_account         = var.billing_account
  folder_id               = google_folder.common.id

  activate_apis = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "servicenetworking.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "billingbudgets.googleapis.com",
    "iamcredentials.googleapis.com",
  ]

  labels = {
    environment       = "production"
    application_name  = "org-base-net-hub"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "abcd"
    env_code          = "p"
  }
  budget_alert_pubsub_topic   = var.base_net_hub_project_alert_pubsub_topic
  budget_alert_spent_percents = var.base_net_hub_project_alert_spent_percents
  budget_amount               = var.base_net_hub_project_budget_amount
}
