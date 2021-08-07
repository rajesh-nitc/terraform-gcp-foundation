# GKE cluster with ACM in a Shared VPC

0. Provision gke-infra
0. Enable nat in 3-networks   
0. Check nomos status
0. Deploy app 
0. Destroy gke-infra
0. Disable nat

Run gke-infra with ```gcloud config set auth/impersonate_service_account project-service-account@prj-gke-d-clusters-3c96.iam.gserviceaccount.com```