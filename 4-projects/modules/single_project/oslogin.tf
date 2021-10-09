# Enable OS Login
resource "google_compute_project_metadata_item" "enable_oslogin" {
  count   = contains(var.activate_apis, "compute.googleapis.com") && var.enable_oslogin ? 1 : 0
  project = module.project.project_id
  key     = "enable-oslogin"
  value   = "TRUE"
}

resource "google_project_iam_member" "grp_oslogin_user" {
  count   = contains(var.activate_apis, "compute.googleapis.com") && var.enable_oslogin ? 1 : 0
  project = module.project.project_id
  role    = "roles/compute.osLogin"
  member  = "group:${var.group_email}"
}