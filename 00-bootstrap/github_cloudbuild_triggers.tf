locals {
  cloudbuild_trigger_repos = [
    "01-org",
    "02-environments",
    "03-networks",
    "04-projects",
    "10-gke-projects",
    "20-data-projects",
  ]

  terraform_service_account = module.seed_bootstrap.terraform_sa_email
}

resource "google_cloudbuild_trigger" "push_non_environment_branch" {
  for_each = toset(local.cloudbuild_trigger_repos)
  provider = google-beta
  project  = module.cloudbuild_bootstrap.cloudbuild_project_id
  name     = "${each.key}-plan"

  github {
    name  = var.github_repo_name
    owner = var.github_user_name

    push {
      branch       = "^(development|production)$"
      invert_regex = true
    }
  }

  included_files = ["${each.key}/**"]

  substitutions = {
    _DEFAULT_REGION = var.default_region
    _GAR_REPOSITORY = module.cloudbuild_bootstrap.tf_runner_artifact_repo
    _TF_SA_EMAIL    = local.terraform_service_account
  }

  filename = "${each.key}/cloudbuild-tf-plan.yaml"
}

resource "google_cloudbuild_trigger" "push_environment_branch" {
  for_each = toset(local.cloudbuild_trigger_repos)
  provider = google-beta
  project  = module.cloudbuild_bootstrap.cloudbuild_project_id
  name     = "${each.key}-apply"

  github {
    name  = var.github_repo_name
    owner = var.github_user_name

    push {
      branch       = "^(development|production)$"
      invert_regex = false
    }
  }

  included_files = ["${each.key}/**"]

  substitutions = {
    _DEFAULT_REGION = var.default_region
    _GAR_REPOSITORY = module.cloudbuild_bootstrap.tf_runner_artifact_repo
    _TF_SA_EMAIL    = local.terraform_service_account
  }

  filename = "${each.key}/cloudbuild-tf-apply.yaml"
}


