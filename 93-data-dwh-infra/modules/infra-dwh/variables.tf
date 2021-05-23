variable "org_id" {
  description = "The organization id for the associated services"
  type        = string
}

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

variable "environment" {
  description = "The environment the resource belongs to"
  type        = string
}

variable "business_code" {
  type    = string
  default = "data"
}