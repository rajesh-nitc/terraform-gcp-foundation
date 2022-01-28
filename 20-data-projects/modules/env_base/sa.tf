# Allow project sa to access tf state
resource "google_storage_bucket_iam_member" "landing_prj_sa_tf_state_bucket" {
  bucket = var.bkt_tfstate
  role   = "roles/storage.admin"
  member = "serviceAccount:${module.landing_project.sa}"
}

resource "google_storage_bucket_iam_member" "transformation_prj_sa_tf_state_bucket" {
  bucket = var.bkt_tfstate
  role   = "roles/storage.admin"
  member = "serviceAccount:${module.transformation_project.sa}"
}

resource "google_storage_bucket_iam_member" "dwh_prj_sa_tf_state_bucket" {
  bucket = var.bkt_tfstate
  role   = "roles/storage.admin"
  member = "serviceAccount:${module.dwh_project.sa}"
}

# Dataflow worker sa roles on other data projects
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