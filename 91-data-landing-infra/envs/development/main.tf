module infra_landing {
  source       = "../../modules/env_base"
  org_id       = var.org_id
  environment  = "development"
  bucket_names = ["raw-data", "data-schema"]
}

