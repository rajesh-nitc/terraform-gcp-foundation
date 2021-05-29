module "workload_identity_frontend" {
  source               = "../../modules/workload-identity"
  org_id               = var.org_id
  environment          = "development"
  app_name             = "app1"
  k8s_app_service_name = "frontend"
  sa_roles             = ["roles/storage.admin"] # Just to test

}
