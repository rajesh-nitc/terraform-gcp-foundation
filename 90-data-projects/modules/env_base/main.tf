module landing_project {
  source                   = "../../../4-projects/modules/single_project"
  org_id                   = var.org_id
  billing_account          = var.billing_account
  environment              = var.environment
  vpc_type                 = ""
  alert_spent_percents     = var.alert_spent_percents
  alert_pubsub_topic       = var.alert_pubsub_topic
  budget_amount            = var.budget_amount
  project_prefix           = var.project_prefix
  enable_hub_and_spoke     = var.enable_hub_and_spoke
  sa_roles                 = [
    "roles/pubsub.admin",
    "roles/storage.admin",
    "roles/resourcemanager.projectIamAdmin"
  ]
  enable_cloudbuild_deploy = true
  cloudbuild_sa            = var.app_infra_pipeline_cloudbuild_sa
  activate_apis = [
    "pubsub.googleapis.com",
    "storage-component.googleapis.com",
  ]

  group_email = var.group_email

  # Metadata
  project_suffix    = "landing"
  application_name  = "landing"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "data"
}

module transformation_project {
  source               = "../../../4-projects/modules/single_project"
  enable_hub_and_spoke = true
  org_id               = var.org_id
  billing_account      = var.billing_account
  environment          = var.environment
  vpc_type             = "base"
  alert_spent_percents = var.alert_spent_percents
  alert_pubsub_topic   = var.alert_pubsub_topic
  budget_amount        = var.budget_amount
  project_prefix       = var.project_prefix
  sa_roles = [
    "roles/dataflow.admin",
    "roles/dataflow.worker",
    "roles/iam.serviceAccountUser",
    "roles/storage.admin",
  ]
  enable_cloudbuild_deploy = true
  cloudbuild_sa            = var.app_infra_pipeline_cloudbuild_sa
  activate_apis = [
    "bigquery.googleapis.com",
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
    "dataflow.googleapis.com",
    "servicenetworking.googleapis.com",
    "storage-component.googleapis.com",
  ]

  group_email = var.group_email

  # Metadata
  project_suffix    = "transformation"
  application_name  = "transformation"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "data"
}

module dwh_project {
  source                   = "../../../4-projects/modules/single_project"
  org_id                   = var.org_id
  billing_account          = var.billing_account
  environment              = var.environment
  vpc_type                 = ""
  alert_spent_percents     = var.alert_spent_percents
  alert_pubsub_topic       = var.alert_pubsub_topic
  budget_amount            = var.budget_amount
  project_prefix           = var.project_prefix
  enable_hub_and_spoke     = var.enable_hub_and_spoke
  sa_roles                 = [
    "roles/bigquery.admin",
    "roles/storage.admin"
  ]
  enable_cloudbuild_deploy = true
  cloudbuild_sa            = var.app_infra_pipeline_cloudbuild_sa
  activate_apis = [
    "bigquery.googleapis.com",
    "bigquerystorage.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "storage-component.googleapis.com",
  ]

  group_email = var.group_email

  # Metadata
  project_suffix    = "dwh"
  application_name  = "dwh"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "data"
}