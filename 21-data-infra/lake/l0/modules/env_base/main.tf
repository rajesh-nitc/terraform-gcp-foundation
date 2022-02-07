module "bq_dataset_l0" {
  source     = "terraform-google-modules/bigquery/google"
  version    = "5.2.0"
  project_id = var.lake_l0_project_id

  dataset_id                  = "bq_dataset_l0"
  dataset_name                = "bq_dataset_l0"
  description                 = "L0 dataset"
  location                    = "US"
  default_table_expiration_ms = 3600000 * 24 * 5

  access = [
    {
      role          = "roles/bigquery.dataEditor"
      user_by_email = format("%s@%s.iam.gserviceaccount.com", "sa-dataflow-worker", var.loading_project_id)
    },
    {
      role           = "roles/bigquery.dataEditor"
      group_by_email = var.group_data_admins
    },

  ]

}

