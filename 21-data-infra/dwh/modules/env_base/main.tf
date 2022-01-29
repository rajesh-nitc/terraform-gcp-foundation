module "bq_dataset" {
  source     = "terraform-google-modules/bigquery/google"
  version    = "5.2.0"
  project_id = var.project_id

  dataset_id                  = "bq_raw_dataset"
  dataset_name                = "bq_raw_dataset"
  description                 = "some description"
  location                    = "US"
  default_table_expiration_ms = 3600000 * 24 * 5

  access = [
    {
      role          = "roles/bigquery.dataOwner"
      user_by_email = format("%s@%s.iam.gserviceaccount.com", "sa-dataflow-worker", var.transformation_project_id)
    },
    {
      role          = "roles/bigquery.dataViewer"
      user_by_email = format("project-service-account@%s.iam.gserviceaccount.com", var.project_id)
    },
    {
      role           = "roles/bigquery.dataOwner"
      group_by_email = var.group_data_admins
    },

  ]

}

