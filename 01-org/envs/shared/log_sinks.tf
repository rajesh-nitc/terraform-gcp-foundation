locals {
  parent_resource_id       = var.parent_folder != "" ? var.parent_folder : var.org_id
  parent_resource_type     = var.parent_folder != "" ? "folder" : "organization"
  vpc_sc_violations_filter = <<EOF
     logName: /logs/cloudaudit.googleapis.com%2Fpolicy
 EOF
}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

/******************************************
  Send logs to BigQuery
*****************************************/

module "log_export_to_biqquery" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0.0"
  destination_uri        = module.bigquery_destination.destination_uri
  filter                 = local.vpc_sc_violations_filter
  log_sink_name          = "sk-c-logging-bq"
  parent_resource_id     = local.parent_resource_id
  parent_resource_type   = local.parent_resource_type
  include_children       = true
  unique_writer_identity = true
  bigquery_options = {
    use_partitioned_tables = true
  }
}

module "bigquery_destination" {
  source                     = "terraform-google-modules/log-export/google//modules/bigquery"
  version                    = "~> 5.1.0"
  project_id                 = module.org_audit_logs.project_id
  dataset_name               = "audit_logs"
  log_sink_writer_identity   = module.log_export_to_biqquery.writer_identity
  expiration_days            = var.audit_logs_table_expiration_days
  delete_contents_on_destroy = var.audit_logs_table_delete_contents_on_destroy
}