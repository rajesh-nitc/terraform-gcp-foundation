module "workload_identity_frontend" {
  source               = "../../modules/workload-identity"
  org_id               = var.org_id
  environment          = "development"
  app_name             = "budita"
  k8s_app_service_name = "frontend"
  pod_sa_roles         = ["roles/storage.admin"] # Example

}
