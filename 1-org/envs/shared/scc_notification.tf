/******************************************
  SCC Notification
*****************************************/

resource "google_pubsub_topic" "scc_notification_topic" {
  name    = "top-scc-notification"
  project = module.scc_notifications.project_id
}

resource "google_pubsub_subscription" "scc_notification_subscription" {
  name    = "sub-scc-notification"
  topic   = google_pubsub_topic.scc_notification_topic.name
  project = module.scc_notifications.project_id
}

module "scc_notification" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 1.1.0"

  additional_components = var.skip_gcloud_download ? [] : ["alpha"]

  create_cmd_entrypoint = "gcloud"
  create_cmd_body       = <<-EOF
    scc notifications create ${var.scc_notification_name} --organization ${var.org_id} \
    --description "SCC Notification for all active findings" \
    --pubsub-topic projects/${module.scc_notifications.project_id}/topics/${google_pubsub_topic.scc_notification_topic.name} \
    --filter "${var.scc_notification_filter}" \
    --project "${module.scc_notifications.project_id}" \
    --impersonate-service-account=${var.terraform_service_account}
EOF

  destroy_cmd_entrypoint = "gcloud"
  destroy_cmd_body       = <<-EOF
  scc notifications delete organizations/${var.org_id}/notificationConfigs/${var.scc_notification_name} \
  --impersonate-service-account ${var.terraform_service_account} \
  --project "${module.scc_notifications.project_id}" \
  --quiet
  EOF
  skip_download          = var.skip_gcloud_download
}
