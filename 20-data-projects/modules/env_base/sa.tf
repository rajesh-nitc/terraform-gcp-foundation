locals {
  transformation_sa_roles_landing_project = [
    "roles/storage.admin",
  ]

  transformation_sa_roles_dwh_project = [
    "roles/bigquery.jobUser" # Required for batch pipeline # Access Denied: Project prj-data-d-dwh-3f33: User does not have bigquery.jobs.create permission in project prj-data-d-dwh-3f33
  ]
}

resource "google_project_iam_member" "transformation_sa_access_landing_project" {
  for_each = toset(local.transformation_sa_roles_landing_project)
  project  = module.landing_project.project_id
  role     = each.key
  member   = "serviceAccount:${module.transformation_project.sa}"
}

resource "google_project_iam_member" "transformation_sa_access_dwh_project" {
  for_each = toset(local.transformation_sa_roles_dwh_project)
  project  = module.dwh_project.project_id
  role     = each.key
  member   = "serviceAccount:${module.transformation_project.sa}"
}