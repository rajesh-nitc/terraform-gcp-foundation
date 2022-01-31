locals {
  iam_roles_m4ce_host_project = [
    "roles/iam.serviceAccountKeyAdmin",
    "roles/iam.serviceAccountCreator",
    "roles/vmmigration.admin",
  ]

  activate_apis_target_projects = [
    "servicemanagement.googleapis.com",
    "servicecontrol.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com"
  ]

  m4ce_default_sa = "service-${module.m4ce_host_project.project_number}@gcp-sa-vmmigration.iam.gserviceaccount.com"
}

module "m4ce_host_project" {
  source          = "../../04-projects/modules/single_project"
  org_id          = var.org_id
  billing_account = var.billing_account
  environment     = "common"
  vpc_type        = ""
  sa_roles        = []

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
  group_iam_roles = local.iam_roles_m4ce_host_project # User roles on m4ce host project

  # Metadata
  project_suffix    = "host"
  application_name  = "m4ce"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "m4ce"
}

resource "google_service_account" "m4ce_connector_sa" {
  project      = module.m4ce_host_project.project_id
  account_id   = "m4ce-connector-sa"
  display_name = "m4ce Connector SA"
}

# m4ce connector sa roles on m4ce host project
resource "google_project_iam_member" "m4ce_connector_sa_roles" {
  for_each = toset(local.iam_roles_m4ce_host_project)
  project  = module.m4ce_host_project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.m4ce_connector_sa.email}"
}