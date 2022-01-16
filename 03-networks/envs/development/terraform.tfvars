org_id                    = "157305482127"
terraform_service_account = "org-terraform@prj-b-seed-6949.iam.gserviceaccount.com"
default_region1           = "us-central1"
default_region2           = "us-west1"
domain                    = "onprem.budita.dev."
enable_hub_and_spoke      = true

private_service_cidr = "10.16.64.0/21"

subnets = [
  # us-central1
  {
    team                  = "bu1"
    subnet_ip             = "10.0.64.0/21"
    region                = "us-central1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range    = {}
  },
  {
    team                  = "data"
    subnet_ip             = "10.0.72.0/21"
    region                = "us-central1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range    = {}
  },
  {
    team                  = "gke"
    subnet_ip             = "10.0.80.0/21"
    region                = "us-central1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range = {
      pod = "100.64.64.0/21"
      svc = "100.64.72.0/21"
    }
  },
  {
    team                  = "ad"
    subnet_ip             = "10.0.88.0/24"
    region                = "us-central1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range    = {}
  },
  {
    team                  = "proxy-only"
    subnet_ip             = "10.0.89.0/24"
    region                = "us-central1"
    enable_flow_logs      = false
    enable_private_access = false
    secondary_ip_range    = {}
    purpose               = "REGIONAL_MANAGED_PROXY"
    role                  = "ACTIVE"
  },
  # us-west1
  {
    team                  = "bu1"
    subnet_ip             = "10.1.64.0/21"
    region                = "us-west1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range    = {}
  },
  {
    team                  = "data"
    subnet_ip             = "10.1.72.0/21"
    region                = "us-west1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range    = {}
  },
  {
    team                  = "gke"
    subnet_ip             = "10.1.80.0/21"
    region                = "us-west1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range    = {}
  },
  {
    team                  = "ad"
    subnet_ip             = "10.1.88.0/24"
    region                = "us-west1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range    = {}
  },
  {
    team                  = "proxy-only"
    subnet_ip             = "10.1.89.0/24"
    region                = "us-west1"
    enable_flow_logs      = false
    enable_private_access = false
    secondary_ip_range    = {}
    purpose               = "REGIONAL_MANAGED_PROXY"
    role                  = "ACTIVE"
  },
]

budita_cluster_uscentral1_cluster_endpoint_for_nodes = "100.64.80.0/28"
budita_cluster_uscentral1_cluster_network_tag        = "gke-budita-d-us-central1"

# Enable nat if acm is used
nat_enabled = false

# DNS on demand
enable_dns_zone_private_googleapis = false
enable_dns_peering                 = false

allow_all_ingress_ranges = [
  "10.2.0.0/24", # onprem
]

allow_all_egress_ranges = [
  "10.2.0.0/24", # onprem

]