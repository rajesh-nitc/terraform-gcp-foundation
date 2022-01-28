output "app_infra_pipeline_cloudbuild_sa" {
  value = module.infra_pipelines.cloudbuild_sa
}

output "app_cicd_build_sa" {
  value = module.cicd_pipeline.app_cicd_build_sa
}

output "state_bucket" {
  description = "GCS Bucket to store TF state"
  value       = module.infra_pipelines.state_bucket
}