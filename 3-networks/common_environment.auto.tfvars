org_id                    = "157305482127"
terraform_service_account = "org-terraform@prj-b-seed-6949.iam.gserviceaccount.com"
default_region1           = "us-central1"
default_region2           = "us-west1"
// The DNS name of peering managed zone. Must end with a period.
domain                            = "example.com."
enable_hub_and_spoke              = true
enable_hub_and_spoke_transitivity = false
access_context_manager_policy_id  = null