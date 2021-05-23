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
  source     = "git@github.com:terraform-google-modules/terraform-google-cloud-storage.git?ref=v2.0.0"
  project_id = local.project_id
  prefix     = ""

  names              = local.bkt_names
  location           = var.bucket_region
  storage_class      = "REGIONAL"
  bucket_policy_only = local.bkt_policy
  versioning         = local.bkt_versioning

}

module "pubsub" {
  source     = "git@github.com:terraform-google-modules/terraform-google-pubsub.git?ref=v2.0.0"
  topic      = "tpc-${local.environment_code}-${var.business_code}-landing"
  project_id = local.project_id
  pull_subscriptions = [
    {
      name                 = "pull" // required
      ack_deadline_seconds = 20     // optional
      # dead_letter_topic       = "projects/my-pubsub-project/topics/example-dl-topic" // optional
      max_delivery_attempts = 5      // optional
      maximum_backoff       = "600s" // optional
      minimum_backoff       = "300s" // optional
      # filter                  = "attributes.domain = \"com\""                        // optional
      enable_message_ordering = true // optional
      service_account         = local.sa_transformation
    }
  ]
}

