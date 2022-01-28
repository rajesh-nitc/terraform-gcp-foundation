# Allow Cloud Build SA to access tfstate bucket
#resource "google_storage_bucket_iam_member" "cb_sa_tfstate" {
#  bucket   = google_storage_bucket.tfstate.name
#  role     = "roles/storage.admin"
#  member   = "serviceAccount:${data.google_project.automation_project.number}@cloudbuild.gserviceaccount.com"
#}

# Allow Cloud Build SA to access cb bucket
resource "google_storage_bucket_iam_member" "cb_sa_cb_bucket" {
  bucket = google_storage_bucket.cloudbuild_artifacts.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${data.google_project.automation_project.number}@cloudbuild.gserviceaccount.com"
}

# Allow cloudbuild to access tf image in bootstrap cb project
# Just to avoid creating tf image for specific bu
resource "google_project_iam_member" "bootstrap_cb_project" {
  project = data.google_projects.bootstrap_cb_project.projects[0].project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${data.google_project.automation_project.number}@cloudbuild.gserviceaccount.com"
}

