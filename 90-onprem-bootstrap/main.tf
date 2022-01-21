resource "google_folder" "onprem" {
  display_name = "${var.folder_prefix}-onprem"
  parent       = "organizations/${var.org_id}"
}

module "onprem_project" {
  source               = "../04-projects/modules/single_project"
  org_id               = var.org_id
  billing_account      = var.billing_account
  environment          = "onprem"
  vpc_type             = ""
  alert_spent_percents = var.alert_spent_percents
  alert_pubsub_topic   = var.alert_pubsub_topic
  budget_amount        = var.budget_amount
  project_prefix       = var.project_prefix

  sa_roles = [
    "roles/compute.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/resourcemanager.projectIamAdmin",
  ]

  activate_apis = [
    "compute.googleapis.com",
    "dns.googleapis.com",
  ]

  group_email = var.group_email

  # Metadata
  project_suffix    = "connectivity"
  application_name  = "onprem"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "onprem"
}