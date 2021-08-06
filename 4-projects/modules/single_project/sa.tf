locals {

  project_sa_default_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/storage.objectViewer"
  ]
}

# Additional roles to project deployment SA created by project factory
resource "google_project_iam_member" "app_infra_pipeline_sa_roles" {
  for_each = toset(concat(var.sa_roles, local.project_sa_default_roles))
  project  = module.project.project_id
  role     = each.value
  member   = "serviceAccount:${module.project.service_account_email}"
}

# To use data sources?
resource "google_folder_iam_member" "folder_browser" {
  count  = var.enable_cloudbuild_deploy ? 1 : 0
  folder = local.folder_id
  role   = "roles/browser"
  member = "serviceAccount:${module.project.service_account_email}"
}

# To use data sources?
resource "google_folder_iam_member" "folder_network_viewer" {
  count  = var.enable_cloudbuild_deploy ? 1 : 0
  folder = local.folder_id
  role   = "roles/compute.networkViewer"
  member = "serviceAccount:${module.project.service_account_email}"
}

# Allow Cloud Build SA to impersonate project sa
# This is for project level infra
resource "google_service_account_iam_member" "cloudbuild_terraform_sa_impersonate_permissions" {
  count              = var.enable_cloudbuild_deploy ? 1 : 0
  service_account_id = module.project.service_account_name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${var.cloudbuild_sa}"
}

# Allow prj admins to impersonate prj sa
resource "google_service_account_iam_member" "prjadmins_impersonate_prj_sa" {
  service_account_id = module.project.service_account_name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "group:${var.group_prj_admins}"
}

# To browse through the resources
resource "google_project_iam_member" "project_admin" {
  project = module.project.project_id
  role    = "roles/viewer"
  member  = "group:${var.group_prj_admins}"
}