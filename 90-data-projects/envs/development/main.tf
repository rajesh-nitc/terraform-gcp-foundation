module projects_data {
  source                           = "../../modules/data-projects"
  terraform_service_account        = var.terraform_service_account
  org_id                           = var.org_id
  billing_account                  = var.billing_account
  environment                      = "development"
  app_infra_pipeline_cloudbuild_sa = var.app_infra_pipeline_cloudbuild_sa
  group_prj_admins                 = var.group_prj_admins
}
