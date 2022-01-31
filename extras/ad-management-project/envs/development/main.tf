module "ad_management_project" {
  source               = "../../../../04-projects/modules/single_project"
  org_id               = var.org_id
  billing_account      = var.billing_account
  environment          = var.environment
  vpc_type             = "base"
  alert_spent_percents = var.alert_spent_percents
  alert_pubsub_topic   = var.alert_pubsub_topic
  budget_amount        = var.budget_amount
  project_prefix       = var.project_prefix
  sa_roles = [
    "roles/compute.admin",
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountAdmin",
  ]

  activate_apis = [
    "compute.googleapis.com",
  ]

  group_email = var.group_email

  # Metadata
  project_suffix    = "mgmt"
  application_name  = "ad-mgmt"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "ad"

}