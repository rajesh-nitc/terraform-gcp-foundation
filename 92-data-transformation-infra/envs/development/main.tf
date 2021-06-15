module infra_transformation {
  source       = "../../modules/env_base"
  org_id       = var.org_id
  environment  = "development"
  bucket_names = ["temp", "templates"]
}
