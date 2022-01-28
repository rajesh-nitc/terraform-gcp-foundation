output "project_id" {
  description = "Project sample project id."
  value       = module.project.project_id
}

output "sa" {
  description = "Project SA email"
  value       = module.project.service_account_email
}

output "project_number" {
  description = "Project sample project number."
  value       = module.project.project_number
}

output "enabled_apis" {
  description = "VPC Service Control services."
  value       = distinct(concat(var.activate_apis, ["billingbudgets.googleapis.com"]))
}

output "worker_sa_dataproc" {
  value = try(google_service_account.worker_sa_dataproc[0].email, null)
}

output "worker_sa_dataflow" {
  value = try(google_service_account.worker_sa_dataflow[0].email, null)
}