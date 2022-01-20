locals {
  restricted_services = yamldecode(file("${path.module}/restricted-services.yaml"))

  # dereference perimeter egress policy names to the actual objects
  vpc_sc_perimeter_egress_policies = {
    for k, v in coalesce(var.vpc_sc_perimeter_egress_policies, {}) :
    k => [
      for i in coalesce(v, []) : var.vpc_sc_egress_policies[i]
      if lookup(var.vpc_sc_egress_policies, i, null) != null
    ]
  }
  # dereference perimeter ingress policy names to the actual objects
  vpc_sc_perimeter_ingress_policies = {
    for k, v in coalesce(var.vpc_sc_perimeter_ingress_policies, {}) :
    k => [
      for i in coalesce(v, []) : var.vpc_sc_ingress_policies[i]
      if lookup(var.vpc_sc_ingress_policies, i, null) != null
    ]
  }
}

# Dry run
module "vpc_sc" {
  source = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/vpc-sc?ref=v12.0.0"

  access_policy = var.access_policy
  access_levels = coalesce(try(var.vpc_sc_access_levels, null), {})

  service_perimeters_regular = {

    # dev regular perimeter
    dev = {
      spec = {
        access_levels = coalesce(
          try(var.vpc_sc_perimeter_access_levels.dev, null), []
        )
        resources               = var.vpc_sc_perimeter_projects.dev
        restricted_services     = local.restricted_services
        egress_policies         = try(local.vpc_sc_perimeter_egress_policies["dev"], null)
        ingress_policies        = try(local.vpc_sc_perimeter_ingress_policies["dev"], null)
        vpc_accessible_services = null
      }
      status                    = null
      use_explicit_dry_run_spec = true
    }

    # common regular perimeter
    common = {
      spec = {
        access_levels = coalesce(
          try(var.vpc_sc_perimeter_access_levels.common, null), []
        )
        resources               = var.vpc_sc_perimeter_projects.common
        restricted_services     = local.restricted_services
        egress_policies         = try(local.vpc_sc_perimeter_egress_policies["common"], null)
        ingress_policies        = try(local.vpc_sc_perimeter_ingress_policies["common"], null)
        vpc_accessible_services = null
      }
      status                    = null
      use_explicit_dry_run_spec = true
    }
  }

  service_perimeters_bridge = {

    # common to dev bridge perimeter
    common_to_dev = {
      status_resources          = null
      spec_resources            = concat(var.vpc_sc_perimeter_projects.common, var.vpc_sc_perimeter_projects.dev)
      use_explicit_dry_run_spec = true
    }

  }

}

