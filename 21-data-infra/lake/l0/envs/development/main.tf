module "infra_dwh" {
  source             = "../../modules/env_base"
  lake_l0_project_id = var.lake_l0_project_id
  loading_project_id = var.loading_project_id
  group_data_admins  = var.group_data_admins
}


