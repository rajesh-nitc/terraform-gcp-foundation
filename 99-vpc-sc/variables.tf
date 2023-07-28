variable "org_id" {
  description = "The organization id for the associated services"
  type        = string
}

variable "access_policy" {
  type = string
}

variable "terraform_service_account" {
  description = "Service account email of the account to impersonate to run Terraform."
  type        = string
}

variable "vpc_sc_access_levels" {
  description = "VPC SC access level definitions."
  type = map(object({
    combining_function = string
    conditions = list(object({
      ip_subnetworks         = list(string)
      members                = list(string)
      negate                 = bool
      regions                = list(string)
      required_access_levels = list(string)
    }))
  }))
  default = {}
}

variable "vpc_sc_egress_policies" {
  description = "VPC SC egress policy defnitions."
  type = map(object({
    egress_from = object({
      identity_type = string
      identities    = list(string)
    })
    egress_to = object({
      operations = list(object({
        method_selectors = list(string)
        service_name     = string
      }))
      resources = list(string)
    })
  }))
  default = {}
}

variable "vpc_sc_ingress_policies" {
  description = "VPC SC ingress policy defnitions."
  type = map(object({
    ingress_from = object({
      identity_type        = string
      identities           = list(string)
      source_access_levels = list(string)
      source_resources     = list(string)
    })
    ingress_to = object({
      operations = list(object({
        method_selectors = list(string)
        service_name     = string
      }))
      resources = list(string)
    })
  }))
  default = {}
}

variable "vpc_sc_perimeter_access_levels" {
  description = "VPC SC perimeter access_levels."
  type = object({
    common = list(string)
    dev    = list(string)
  })
  default = null
}

variable "vpc_sc_perimeter_egress_policies" {
  description = "VPC SC egress policies per perimeter, values reference keys defined in the `vpc_sc_ingress_policies` variable."
  type = object({
    common = list(string)
    dev    = list(string)
  })
  default = null
}

variable "vpc_sc_perimeter_ingress_policies" {
  description = "VPC SC ingress policies per perimeter, values reference keys defined in the `vpc_sc_ingress_policies` variable."
  type = object({
    common = list(string)
    dev    = list(string)
  })
  default = null
}

variable "vpc_sc_perimeter_projects" {
  description = "VPC SC perimeter resources."
  type = object({
    common = list(string)
    dev    = list(string)
  })
  default = null
}