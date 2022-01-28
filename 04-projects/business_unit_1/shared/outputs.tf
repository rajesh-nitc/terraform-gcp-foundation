output "cloudbuild_sa" {
  description = "Cloud Build service account"
  value       = module.infra_pipelines.cloudbuild_sa
}

output "artifact_bucket" {
  description = "GCS Bucket to store Cloud Build Artifacts"
  value       = module.infra_pipelines.artifact_bucket
}

output "state_bucket" {
  description = "GCS Bucket to store TF state"
  value       = module.infra_pipelines.state_bucket
}
