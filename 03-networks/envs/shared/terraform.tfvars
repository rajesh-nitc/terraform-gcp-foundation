org_id                            = "157305482127"
terraform_service_account         = "org-terraform@prj-b-seed-6949.iam.gserviceaccount.com"
default_region1                   = "us-central1"
default_region2                   = "us-west1"
enable_hub_and_spoke              = true
enable_hub_and_spoke_transitivity = false
access_context_manager_policy_id  = null

domain                             = "onprem.budita.dev."
enable_dns_zone_private_googleapis = false
enable_dns_peering                 = false
enable_dns_forwarding              = false

target_name_server_addresses = ["10.2.0.2"]

allow_all_ingress_ranges = null

allow_all_egress_ranges = [
  "10.0.64.0/18" # dev

]