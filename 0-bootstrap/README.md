## bootstrap
1. Comment out backend.tf, provider.tf and apply terraform manually
1. Update backend.tf, provider.tf, cloudbuild-tf-plan.yaml with values from terraform output
1. Integrate Github repo with Cloud Build via Github App trigger 
1. Create 3 triggers manually: 0-bootstrap-plan, 0-bootstrap-pr-plan and 0-bootstrap-apply and configure them with included files filter as 0-bootstrap/**