locals {
  folder_id                 = data.google_active_folder.env.name
  project_id                = data.google_project.landing_project.project_id
  project_id_transformation = data.google_project.transformation_project.project_id
  environment_code          = element(split("", var.environment), 0)
  bkt_names                 = [for bucket in toset(var.bucket_names) : "bkt-${local.environment_code}-${var.business_code}-landing-${bucket}"]
  bkt_policy                = { for bucket in toset(local.bkt_names) : bucket => true }
  bkt_versioning            = { for bucket in toset(local.bkt_names) : bucket => true }
  sa_transformation         = format("project-service-account@%s.iam.gserviceaccount.com", local.project_id_transformation)
}

module "buckets_landing" {
  source     = "terraform-google-modules/cloud-storage/google"
  version    = "2.1.0"
  project_id = local.project_id
  prefix     = ""

  names              = local.bkt_names
  location           = var.bucket_region
  storage_class      = "REGIONAL"
  bucket_policy_only = local.bkt_policy
  versioning         = local.bkt_versioning

}

module "pubsub" {
  source     = "terraform-google-modules/pubsub/google"
  version    = "3.0.0"
  topic      = "tp-${local.environment_code}-${var.business_code}-landing"
  project_id = local.project_id
  pull_subscriptions = [
    {
      name                    = "sub-dataflow"
      ack_deadline_seconds    = 20
      max_delivery_attempts   = 5
      maximum_backoff         = "600s"
      minimum_backoff         = "300s"
      enable_message_ordering = true
      service_account         = local.sa_transformation
    }
  ]
}

