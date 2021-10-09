# Allow Cloud Build SA to impersonate project sa
# This is for project level infra
resource "google_service_account_iam_member" "cloudbuild_terraform_sa_impersonate_permissions" {
  count              = var.enable_cloudbuild_deploy ? 1 : 0
  service_account_id = module.project.service_account_name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${var.cloudbuild_sa}"
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