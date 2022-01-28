resource "google_project_iam_member" "worker_sa_dataflow_access_landing_project" {
  for_each = toset(local.worker_sa_dataflow_roles_landing_project)
  project  = module.landing_project.project_id
  role     = each.key
  member   = "serviceAccount:${module.transformation_project.worker_sa_dataflow}"
}

resource "google_project_iam_member" "worker_sa_dataflow_access_dwh_project" {
  for_each = toset(local.worker_sa_dataflow_roles_dwh_project)
  project  = module.dwh_project.project_id
  role     = each.key
  member   = "serviceAccount:${module.transformation_project.worker_sa_dataflow}"
}