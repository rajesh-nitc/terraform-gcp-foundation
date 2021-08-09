module gke_project {
  source                           = "../../modules/env_base"
  terraform_service_account        = var.terraform_service_account
  org_id                           = var.org_id
  project_id                       = "prj-gke-d-clusters-3c96" # destroyed the project by mistake, imported it as gcp was not allowing to create new project because of quota
  billing_account                  = var.billing_account
  environment                      = "development"
  app_cicd_project_id              = var.app_cicd_project_id
  app_infra_pipeline_cloudbuild_sa = var.app_infra_pipeline_cloudbuild_sa
  group_prj_admins                 = var.group_prj_admins
  cicd_sa                          = var.cicd_sa
}

