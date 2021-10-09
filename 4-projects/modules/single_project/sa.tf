# Additional roles to project deployment SA created by project factory
resource "google_project_iam_member" "prj_sa_roles" {
  for_each = toset(var.sa_roles)
  project  = module.project.project_id
  role     = each.value
  member   = "serviceAccount:${module.project.service_account_email}"
}