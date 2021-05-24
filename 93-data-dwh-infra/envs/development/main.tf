module infra_dwh {
  source            = "../../modules/infra-dwh"
  org_id            = var.org_id
  environment       = "development"
  group_data_admins = var.group_data_admins
}


