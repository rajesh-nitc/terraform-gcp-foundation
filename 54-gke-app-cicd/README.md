# GKE Sample CICD pipeline

**guideline**: Every pull request to main branch should create a new PR namespace in a separate PR/test cluster. All the components to be deployed e.g. database, backend etc. 

**deviation**: we here have only 1 cluster to work with i.e. dev cluster. PR to main branch will deploy frontend app to frontend namespace in dev cluster.