output "app_infra_pipeline_cloudbuild_sa" {
  value = module.infra_pipelines.cloudbuild_sa
}

output "app_cicd_build_sa" {
  value = module.cicd_pipeline.app_cicd_build_sa
}