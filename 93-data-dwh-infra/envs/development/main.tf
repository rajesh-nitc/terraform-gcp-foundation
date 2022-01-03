module "infra_dwh" {
  source            = "../../modules/env_base"
  org_id            = var.org_id
  environment       = "development"
  group_data_admins = var.group_data_admins
}


