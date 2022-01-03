# GKE Sample CICD pipeline

**Guideline_1**: Each PR to main branch should create a new PR namespace in a Staging / PR / Pre-prod cluster. 

**Actual_1**: PR to main branch will deploy frontend service to frontend namespace in dev cluster.

**Guideline_2**: Private pools to be used to deploy apps on Private GKE cluster.

**Actual_2**: we have allowed external access to the gke control plane for testing the cicd pipeline.