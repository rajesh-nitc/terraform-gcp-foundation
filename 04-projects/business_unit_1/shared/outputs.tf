output "cloudbuild_sa" {
  description = "Cloud Build service account"
  value       = module.infra_pipelines.cloudbuild_sa
}

output "artifact_buckets" {
  description = "GCS Buckets to store Cloud Build Artifacts"
  value       = module.infra_pipelines.artifact_buckets
}

output "state_buckets" {
  description = "GCS Buckets to store TF state"
  value       = module.infra_pipelines.state_buckets
}
