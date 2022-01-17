project_id                = "prj-onprem-o-connectivity-53cd"
net_hub_project_id        = "prj-c-base-net-hub-74f5"
dns_hub_project_id        = "prj-c-dns-hub-c4a2"
net_hub_self_link         = "https://www.googleapis.com/compute/v1/projects/prj-c-base-net-hub-74f5/global/networks/vpc-c-shared-base-hub"
dns_hub_self_link         = "https://www.googleapis.com/compute/v1/projects/prj-c-dns-hub-c4a2/global/networks/vpc-c-dns-hub"
default_region1           = "us-central1"
default_region2           = "us-west1"
terraform_service_account = "org-terraform@prj-b-seed-6949.iam.gserviceaccount.com"
domain                    = "onprem.budita.dev."
private_ip                = "10.2.0.5"
hostname                  = "host1"

sharedvpc_cidr = {
  "hub" = {
    "us-central1" = "10.0.0.0/18"
    "us-west1"    = "10.1.0.0/18"
  }

  "dev" = {
    "us-central1" = "10.0.64.0/18"
    "us-west1"    = "10.1.64.0/18"
  }
}

bgp_session_range = {
  "us-central1" = {
    "net-hub" = "169.254.1.0/30" # single tunnel
    "dns-hub" = "169.254.2.0/30" # single tunnel
  }
}

router_asn = {
  "onprem"  = "64515"
  "net-hub" = "64516"
  "dns-hub" = "64517"
}