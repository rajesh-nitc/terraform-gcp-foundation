# GKE cluster with ACM in a Shared VPC

- ASM is the recommended option but not implemented yet. We are using Istio addon (deprecated now) which comes with default options (external tcp network load balancer). 
- Not registered the cluster with gke hub. We are using acm as a standalone feature. 
- Private pools is the recommended option but for simplicity, we have allowed external access to the gke control plane to test the cicd from cloud build. 