locals {
  folder_id         = data.google_active_folder.env.name
  project_id        = data.google_project.transformation_project.project_id
  environment_code  = element(split("", var.environment), 0)
  bkt_names         = [for bucket in toset(var.bucket_names) : "bkt-${local.environment_code}-${var.business_code}-dataflow-${bucket}"]
  bkt_policy        = { for bucket in toset(local.bkt_names) : bucket => true }
  bkt_versioning    = { for bucket in toset(local.bkt_names) : bucket => false }
  bkt_force_destroy = { for bucket in toset(local.bkt_names) : bucket => true }
}

module "dataflow_buckets" {
  source     = "terraform-google-modules/cloud-storage/google"
  version    = "3.0.0"
  project_id = local.project_id
  prefix     = ""

  names              = local.bkt_names
  location           = var.bucket_region
  storage_class      = "REGIONAL"
  bucket_policy_only = local.bkt_policy
  versioning         = local.bkt_versioning
  force_destroy      = local.bkt_force_destroy

}

