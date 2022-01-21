module "base_shared_vpc_project" {
  source               = "../../modules/single_project"
  org_id               = var.org_id
  random_project_id    = false
  project_id           = "prj-bu1-d-sample-base-9208" # destroyed the project by mistake, imported it as gcp was not allowing to create new project because of quota
  billing_account      = var.billing_account
  environment          = "development"
  vpc_type             = "base"
  alert_spent_percents = var.alert_spent_percents
  alert_pubsub_topic   = var.alert_pubsub_topic
  budget_amount        = var.budget_amount
  project_prefix       = var.project_prefix
  sa_roles = [
    "roles/compute.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
  ]
  enable_cloudbuild_deploy = true
  cloudbuild_sa            = var.app_infra_pipeline_cloudbuild_sa
  activate_apis = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
  ]

  group_email = var.group_email

  # Metadata
  project_suffix    = "sample-base"
  application_name  = "sample-application"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "bu1"

}

