resource "google_project_iam_member" "user_compute_viewer_host_prj" {
  project = var.host_project_id
  role    = "roles/compute.viewer"
  member  = "group:${var.group_email}"
}

# All m4ce to access all subnets on host project
resource "google_project_iam_member" "m4ce_sa_networkuser_host_prj" {
  project = var.host_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${local.m4ce_default_sa}"
}