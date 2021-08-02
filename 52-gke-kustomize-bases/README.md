# GKE Shared Kustomize Bases

**guideline**: Security and Network policies should be managed by platform admins. Application service specific yamls (for e.g. frontend service yamls in this case) should go in separate frontend folder.

**deviation**: All the resources are managed by single cicd pipeline and applied in one go.