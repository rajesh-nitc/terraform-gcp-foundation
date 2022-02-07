# Dataflow worker sa roles on landing prj
resource "google_project_iam_member" "worker_sa_dataflow_access_landing_project" {
  for_each = toset(local.worker_sa_dataflow_roles_landing_project)
  project  = module.landing_project.project_id
  role     = each.key
  member   = "serviceAccount:${module.loading_project.worker_sa_dataflow}"
}

# Dataflow worker sa roles on lake-l0 prj
resource "google_project_iam_member" "worker_sa_dataflow_access_lake_l0_project" {
  for_each = toset(local.worker_sa_dataflow_roles_lake_l0_project)
  project  = module.lake_l0_project.project_id
  role     = each.key
  member   = "serviceAccount:${module.loading_project.worker_sa_dataflow}"
}