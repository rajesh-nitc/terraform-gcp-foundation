module infra_transformation {
  source       = "../../modules/infra-transformation"
  org_id       = var.org_id
  environment  = "development"
  bucket_names = ["temp", "templates"]
}
