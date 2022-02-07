variable "project_service_account" {
  description = "Project sa for data-dwh"
  type        = string
}

variable "lake_l0_project_id" {
  type = string
}

variable "loading_project_id" {
  type = string
}

variable "group_data_admins" {
  type = string
}
