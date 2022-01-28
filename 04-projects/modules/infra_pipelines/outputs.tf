output "cloudbuild_sa" {
  description = "Cloud Build service account"
  value       = "${data.google_project.automation_project.number}@cloudbuild.gserviceaccount.com"
}

output "artifact_bucket" {
  description = "GCS Bucket to store Cloud Build Artifacts"
  value       = google_storage_bucket.cloudbuild_artifacts.name
}

output "state_bucket" {
  description = "GCS Bucket to store TF state"
  value       = google_storage_bucket.tfstate.name
}
