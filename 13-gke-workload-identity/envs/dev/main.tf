module "workload_identity_frontend" {
  source               = "../../modules/env_base"
  org_id               = var.org_id
  environment          = "development"
  app_name             = "budita"
  k8s_app_service_name = "frontend"
  pod_sa_roles_gke_prj = ["roles/storage.admin"]

}
