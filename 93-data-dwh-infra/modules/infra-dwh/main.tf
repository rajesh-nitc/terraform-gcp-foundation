locals {
  folder_id                 = data.google_active_folder.env.name
  project_id                = data.google_project.dwh_project.project_id
  project_id_transformation = data.google_project.transformation_project.project_id
  environment_code          = element(split("", var.environment), 0)
}

module "bq_dataset" {
  source     = "git@github.com:terraform-google-modules/terraform-google-bigquery.git?ref=v5.1.0"
  project_id = local.project_id

  dataset_id                  = "bq_raw_dataset"
  dataset_name                = "bq_raw_dataset"
  description                 = "some description"
  location                    = "US"
  default_table_expiration_ms = 3600000

  access = [
    {
      role          = "roles/bigquery.dataOwner"
      user_by_email = format("project-service-account@%s.iam.gserviceaccount.com", local.project_id_transformation)
    },
    {
      role          = "roles/bigquery.dataViewer"
      user_by_email = format("project-service-account@%s.iam.gserviceaccount.com", local.project_id)
    },
    {
      role           = "roles/bigquery.dataOwner"
      group_by_email = var.group_data_admins
    },

  ]

}

