locals {
  group_iam_roles = [
    "roles/iam.serviceAccountKeyAdmin",
    "roles/iam.serviceAccountCreator",
    "roles/vmmigration.admin",
  ]
}

module "m4ce_host_project" {
  source                   = "../4-projects/modules/single_project"
  org_id                   = var.org_id
  billing_account          = var.billing_account
  environment              = "common"
  vpc_type                 = ""
  sa_roles                 = []
  enable_cloudbuild_deploy = false
  cloudbuild_sa            = ""

  activate_apis = [
    "vmmigration.googleapis.com",
    "servicemanagement.googleapis.com",
    "servicecontrol.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
  ]

  group_email     = var.group_email
  group_iam_roles = local.group_iam_roles

  # Metadata
  project_suffix    = "host"
  application_name  = "m4ce"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "m4ce"
}