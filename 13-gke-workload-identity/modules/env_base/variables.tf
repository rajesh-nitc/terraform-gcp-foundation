variable "org_id" {
  description = "The organization id for the associated services"
  type        = string
}

variable "parent_folder" {
  type    = string
  default = ""
}

variable "environment" {
  type = string
}

variable "folder_prefix" {
  type        = string
  description = "Name prefix to use for folders created."
  default     = "fldr"
}

variable "business_code" {
  type    = string
  default = "gke"
}

variable "app_name" {
  type = string
}

variable "k8s_app_service_name" {
  type = string
}

variable "pod_sa_roles_gke_prj" {
  type    = list(string)
  default = []
}
