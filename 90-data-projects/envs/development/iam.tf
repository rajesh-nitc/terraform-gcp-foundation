module transformation_sa_iam {
  source          = "../../modules/data-iam"
  project_landing = module.landing_project.project_id
  sa_landing      = module.landing_project.sa
  project_dwh     = module.dwh_project.project_id
  sa_dwh          = module.dwh_project.sa
}
