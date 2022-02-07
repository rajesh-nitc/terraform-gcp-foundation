org_id                    = "157305482127"
access_policy             = "57968632121"
terraform_service_account = "org-terraform@prj-b-seed-6949.iam.gserviceaccount.com"

vpc_sc_perimeter_projects = {
  dev = [
    "projects/195126579545", # host
    "projects/473976687661", # gke
    "projects/746892598413", # data-landing
    "projects/922340859450", # data-loading
    "projects/623745241425", # data-lake-l0
    "projects/770674777462", # bu1
  ]
  common = [
    "projects/626802511012",  # net-hub
    "projects/571446104349",  # dns-hub
    "projects/1099039660751", # logging
    # Cloud build Pipelines need access to internet
    # Bootstrap seed and cicd projects are not part of any parameter
    # Project level infra and cicd pipeline projects are also kept outside
    # "projects/869249260424",  # gke-infra-pipeline
    # "projects/675820069328",  # gke-cicd-pipeline
    # "projects/566416973195",  # data-infra-pipeline
    # "projects/310418294350",  # bu1-infra-pipeline
  ]
}

# Allow unconditional access from a set of cidrs
vpc_sc_access_levels = {
  home = {
    combining_function = null
    conditions = [{
      ip_subnetworks = ["223.190.84.25/32"],
      members        = null, negate = null,
      regions        = null, required_access_levels = null
    }]
  }
}

vpc_sc_perimeter_access_levels = {
  dev    = ["home"]
  common = ["home"]
}

# Running terraform locally and console access for admin user
vpc_sc_ingress_policies = {

  iac = {
    ingress_from = {
      identities = [

        # Users impersonating the below service accounts should also be added here
        # For simplicity, we have admin user impersonating all the service accounts
        "user:admin@budita.dev",
        "serviceAccount:org-terraform@prj-b-seed-6949.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-gke-d-clusters-3c96.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-data-d-landing-0816.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-data-d-loading-82c5.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-data-d-lake-l0-ffe8.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-bu1-d-sample-base-9208.iam.gserviceaccount.com",

        # Cloud build will be impersonating the above service accounts
        # don't think we need to include cloud build sa's here as tfstate buckets and cloud build are both outside perimeters

      ]

      source_access_levels = ["*"]
      identity_type        = null
      source_resources     = null
    }
    ingress_to = {
      operations = [{ method_selectors = [], service_name = "*" }]
      resources  = ["*"]
    }
  }

  logsink = {
    ingress_from = {
      identities = [

        # Org log sink sa residing at org level
        "serviceAccount:o157305482127-456794@gcp-sa-logging.iam.gserviceaccount.com",

      ]
      source_access_levels = ["*"]
      identity_type        = null
      source_resources     = null
    }
    ingress_to = {
      operations = [{ method_selectors = [], service_name = "*" }]
      resources = [
        "projects/1099039660751" # logging
      ]
    }
  }

}

# Enable ingress policies on selected perimeters
vpc_sc_perimeter_ingress_policies = {
  dev    = ["iac"]
  common = ["iac", "logsink"]
}

vpc_sc_egress_policies = null

vpc_sc_perimeter_egress_policies = null