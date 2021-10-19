# Additional roles to project deployment SA created by project factory
resource "google_project_iam_member" "prj_sa_roles" {
  for_each = toset(var.sa_roles)
  project  = module.project.project_id
  role     = each.value
  member   = "serviceAccount:${module.project.service_account_email}"
}

# Allow project sa to perform folder/project lookups
resource "google_folder_iam_member" "folder_browser" {
  folder = local.folder_id
  role   = "roles/browser"
  member = "serviceAccount:${module.project.service_account_email}"
}

resource "google_folder_iam_member" "folder_network_viewer" {
  folder = local.folder_id
  role   = "roles/compute.networkViewer"
  member = "serviceAccount:${module.project.service_account_email}"
}