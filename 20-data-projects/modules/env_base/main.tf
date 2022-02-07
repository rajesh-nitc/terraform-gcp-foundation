locals {
  worker_sa_dataflow_roles_landing_project = [
    "roles/storage.objectViewer",
  ]

  worker_sa_dataflow_roles_lake_l0_project = [
    "roles/bigquery.jobUser"
  ]
}

module "landing_project" {
  source               = "../../../04-projects/modules/single_project"
  org_id               = var.org_id
  billing_account      = var.billing_account
  environment          = var.environment
  vpc_type             = ""
  alert_spent_percents = var.alert_spent_percents
  alert_pubsub_topic   = var.alert_pubsub_topic
  budget_amount        = var.budget_amount
  project_prefix       = var.project_prefix
  sa_roles = [
    "roles/pubsub.admin",
    "roles/storage.admin",
    "roles/resourcemanager.projectIamAdmin", # Error: Request `Create IAM Members roles/iam.serviceAccountTokenCreator serviceAccount:service-746892598413@gcp-sa-pubsub.iam.gserviceaccount.com for project "prj-data-d-landing-0816"` returned error: Error applying IAM policy for project "prj-data-d-landing-0816": Error setting IAM policy for project "prj-data-d-landing-0816": googleapi: Error 403: Policy update access denied., forbidden
  ]
  enable_cloudbuild_deploy = true
  cloudbuild_sa            = var.app_infra_pipeline_cloudbuild_sa
  activate_apis = [
    "pubsub.googleapis.com",
    "storage.googleapis.com",
    "storage-component.googleapis.com",
  ]

  group_email = var.group_email
  bkt_tfstate = var.bkt_tfstate

  # Metadata
  project_suffix    = "landing"
  application_name  = "landing"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "data"
}

# Dataflow worker sa is managed as part of single_project module
module "loading_project" {
  source               = "../../../04-projects/modules/single_project"
  org_id               = var.org_id
  billing_account      = var.billing_account
  environment          = var.environment
  vpc_type             = "base"
  alert_spent_percents = var.alert_spent_percents
  alert_pubsub_topic   = var.alert_pubsub_topic
  budget_amount        = var.budget_amount
  project_prefix       = var.project_prefix
  sa_roles = [
    "roles/storage.admin",
  ]

  enable_cloudbuild_deploy = true
  cloudbuild_sa            = var.app_infra_pipeline_cloudbuild_sa
  activate_apis = [
    "bigquery.googleapis.com",
    "compute.googleapis.com",
    "dataflow.googleapis.com",
    "storage.googleapis.com",
    "storage-component.googleapis.com",
  ]

  group_email = var.group_email
  bkt_tfstate = var.bkt_tfstate

  # Metadata
  project_suffix    = "loading"
  application_name  = "loading"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "data"
}

module "lake_l0_project" {
  source               = "../../../04-projects/modules/single_project"
  org_id               = var.org_id
  billing_account      = var.billing_account
  environment          = var.environment
  vpc_type             = ""
  alert_spent_percents = var.alert_spent_percents
  alert_pubsub_topic   = var.alert_pubsub_topic
  budget_amount        = var.budget_amount
  project_prefix       = var.project_prefix
  sa_roles = [
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
  bkt_tfstate = var.bkt_tfstate

  # Metadata
  project_suffix    = "lake-l0"
  application_name  = "lake"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "data"
}