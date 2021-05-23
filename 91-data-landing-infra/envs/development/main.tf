module infra_landing {
  source       = "../../modules/infra-landing"
  org_id       = var.org_id
  environment  = "development"
  bucket_names = ["raw-data", "data-schema"]
}

