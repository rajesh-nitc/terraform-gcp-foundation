module "infra_dwh" {
  source                    = "../../modules/env_base"
  project_id                = var.project_id
  transformation_project_id = var.transformation_project_id
  group_data_admins         = var.group_data_admins
}


