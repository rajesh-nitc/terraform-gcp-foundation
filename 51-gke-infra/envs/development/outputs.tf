output "git_creds_public" {
  description = "Public key of SSH keypair to allow the Anthos Config Management Operator to authenticate to your Git repository."
  value       = module.gke_cluster.git_creds_public
}
