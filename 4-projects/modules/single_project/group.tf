resource "google_project_iam_member" "project_admin" {
  project  = module.project.project_id
  role     = "roles/editor"
  member   = "group:${var.group_prj_admins}"
}