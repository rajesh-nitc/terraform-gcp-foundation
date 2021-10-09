module "app_infra_cloudbuild_project" {
  source               = "../../../4-projects/modules/single_project"
  org_id               = var.org_id
  billing_account      = var.billing_account
  environment          = "common"
  alert_spent_percents = var.alert_spent_percents
  alert_pubsub_topic   = var.alert_pubsub_topic
  budget_amount        = var.budget_amount
  project_prefix       = var.project_prefix
  activate_apis = [
    "cloudbuild.googleapis.com",
    "sourcerepo.googleapis.com",
    "cloudkms.googleapis.com",
    "iam.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]

  group_email = var.group_email

  # Metadata
  project_suffix    = "infra-pipeline"
  application_name  = "app-infra-pipelines"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "data"

}

module "infra_pipelines" {
  source = "../../../4-projects/modules/infra_pipelines"

  cloudbuild_project_id = module.app_infra_cloudbuild_project.project_id
  business_code         = "data"
  org_id                = var.org_id
  monorepo_folders      = ["91-data-landing-infra", "92-data-transformation-infra", "93-data-dwh-infra"]
  group_email      = var.group_email
}

