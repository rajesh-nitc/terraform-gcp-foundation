## bootstrap
1. Step 1: Comment out backend.tf and provider.tf and apply terraform manually
1. Step 2: Update backend.tf, provider.tf, cloudbuild-tf-plan.yaml 
1. Step 3: Integrate Github repo with Cloud Build via Github App trigger and configure build trigger included files filter as 0-bootstrap/**