variable "org_id" {
  description = "The organization id for the associated services"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associated this project with"
  type        = string
}

variable "impersonate_service_account" {
  description = "Service account email of the account to impersonate to run Terraform"
  type        = string
}

variable "project_suffix" {
  description = "The name of the GCP project. Max 16 characters with 3 character business unit code."
  type        = string
}

variable "application_name" {
  description = "The name of application where GCP resources relate"
  type        = string
}

variable "billing_code" {
  description = "The code that's used to provide chargeback information"
  type        = string
}

variable "primary_contact" {
  description = "The primary email contact for the project"
  type        = string
}

variable "secondary_contact" {
  description = "The secondary email contact for the project"
  type        = string
  default     = ""
}

variable "business_code" {
  description = "The code that describes which business unit owns the project"
  type        = string
  default     = "abcd"
}

variable "activate_apis" {
  description = "The api to activate for the GCP project"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "vpc_type" {
  description = "The type of VPC to attach the project to. Possible options are base or restricted."
  type        = string
  default     = ""
}

variable "vpc_service_control_attach_enabled" {
  description = "Whether the project will be attached to a VPC Service Control Perimeter"
  type        = bool
  default     = false
}

variable "vpc_service_control_perimeter_name" {
  description = "The name of a VPC Service Control Perimeter to add the created project to"
  type        = string
  default     = null
}

variable "alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded"
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}`"
  type        = string
  default     = null
}

variable "budget_amount" {
  description = "The amount to use as the budget"
  type        = number
  default     = 1000
}

variable "project_prefix" {
  description = "Name prefix to use for projects created."
  type        = string
  default     = "prj"
}

variable "enable_hub_and_spoke" {
  description = "Enable Hub-and-Spoke architecture."
  type        = bool
  default     = false
}

variable "sa_roles" {
  description = "A list of roles to give the Service Account for the project (defaults to none)"
  type        = list(string)
  default     = []
}

variable "enable_cloudbuild_deploy" {
  description = "Enable infra deployment using Cloud Build"
  type        = bool
  default     = false
}

variable "cloudbuild_sa" {
  description = "The Cloud Build SA used for deploying infrastructure in this project. It will impersonate the new default SA created"
  type        = string
  default     = ""
}

variable "group_prj_admins" {
  type = string
}

# variable "svpc_host_project_id" {
#   type    = string
#   default = ""
# }

# variable "shared_vpc_subnets" {
#   type    = list(string)
#   default = []
# }

variable "folder_prefix" {
  description = "Name prefix to use for folders created. Should be the same in all steps."
  type        = string
  default     = "fldr"
}

variable "parent_folder" {
  description = "Optional - for an organization with existing projects or for development/validation. It will place all the example foundation resources under the provided folder instead of the root organization. The value is the numeric folder ID. The folder must already exist. Must be the same value used in previous step."
  type        = string
  default     = ""
}