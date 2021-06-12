module gke_project {
  source                           = "../../modules/env_base"
  terraform_service_account        = var.terraform_service_account
  org_id                           = var.org_id
  billing_account                  = var.billing_account
  environment                      = "development"
  app_cicd_project_id              = var.app_cicd_project_id
  app_infra_pipeline_cloudbuild_sa = var.app_infra_pipeline_cloudbuild_sa
  group_prj_admins                 = var.group_prj_admins
  cicd_sa                          = var.cicd_sa
}

