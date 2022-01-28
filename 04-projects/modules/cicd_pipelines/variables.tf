# variable "app_cicd_build_sa" {
#   description = "Service account email of the account to impersonate to run Terraform"
#   type        = string
# }

variable "app_cicd_project_id" {
  type        = string
  description = "Project ID for CICD Pipeline Project"
}

variable "primary_location" {
  type        = string
  description = "Region used for key-ring"
  default     = "us-central1"
}

variable "attestor_names_prefix" {
  description = "A list of Cloud Source Repos to be created to hold app infra Terraform configs"
  type        = list(string)
  default     = ["build", "quality", "security"]
}

variable "build_app_yaml" {
  type        = string
  description = "Name of application cloudbuild yaml file"
  default     = "cloudbuild-build-boa.yaml"
}

variable "build_image_yaml" {
  type        = string
  description = "Name of image builder yaml file"
  default     = "cloudbuild-skaffold-build-image.yaml"
}

variable "gar_repo_name_suffix" {
  type        = string
  description = "Docker artifact regitery repo to store app build images"
  default     = "boa-image-repo"
}

variable "group_email" {
  type = string
}

variable "cloudbuild_trigger_repos" {
  type = list(string)
}
