# GKE Sample CICD pipeline

- Each PR to main branch should create a new PR namespace in a Staging / PR / Pre-prod cluster. In current implementation, PR to main branch will deploy frontend service to frontend namespace in dev cluster.
- Private pools is the recommended option but for simplicity, we have allowed external access to the gke control plane to test the cicd from cloud build.