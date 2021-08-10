# GKE Sample CICD pipeline

**Guideline_1**: Every pull request to main branch should create a new PR namespace in a separate PR/test cluster. All the components to be deployed e.g. database, backend etc. 

**Actual_1**: we here have only 1 cluster to work with i.e. dev cluster. PR to main branch will deploy frontend app to frontend namespace in dev cluster.

**Guideline_2**: Private pools to be used to deploy apps on Private GKE cluster.

**Actual_2**: we have allowed external access to the gke control plane to test the cicd.