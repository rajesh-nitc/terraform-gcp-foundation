resource "google_project_iam_member" "prj_iam_admin_target_projects" {
  for_each = toset(var.target_projects)
  project  = each.value
  role     = "roles/resourcemanager.projectIamAdmin"
  member   = "group:${var.group_email}"
}

resource "google_project_iam_member" "sa_user_target_projects" {
  for_each = toset(var.target_projects)
  project  = each.value
  role     = "roles/iam.serviceAccountUser"
  member   = "group:${var.group_email}"
}