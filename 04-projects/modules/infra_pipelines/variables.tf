variable "project_prefix" {
  description = "Name prefix to use for projects created."
  type        = string
  default     = "prj"
}

variable "automation_project_id" {
  description = "The project id where the pipelines and repos should be created"
  type        = string
}

variable "bucket_region" {
  description = "Region to create GCS buckets for tfstate and Cloud Build artifacts"
  type        = string
  default     = "us-central1"
}

variable "business_code" {
  description = "The code that describes which business unit owns the project e.g. bu1"
  type        = string
}

variable "parent_folder" {
  description = "Optional - for an organization with existing projects or for development/validation. It will place all the example foundation resources under the provided folder instead of the root organization. The value is the numeric folder ID. The folder must already exist. Must be the same value used in previous step."
  type        = string
  default     = ""
}

variable "org_id" {
  type        = string
  description = "Organization ID"
}

variable "folder_prefix" {
  description = "Name prefix to use for folders created. Should be the same in all steps."
  type        = string
  default     = "fldr"
}

variable "folders_to_grant_browser_role" {
  description = "List of folders to grant browser role to the cloud build service account. Used by terraform validator to able to load IAM policies."
  type        = list(string)
  default     = []
}

variable "cloudbuild_trigger_repos" {
  type    = list(string)
  default = []
}

variable "github_repo_name" {
  type = string
}

variable "github_user_name" {
  type = string
}