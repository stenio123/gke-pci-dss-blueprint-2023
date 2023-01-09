# Anthos Service Mesh

module "asm" {
  source            = "terraform-google-modules/kubernetes-engine/google//modules/asm"
  project_id        = module.service-project-in-scope.project_id
  cluster_name      = "gke-in-scope"
  cluster_location  = module.gke-in-scope.location
  enable_cni        = true
  enable_fleet_registration = true
  enable_mesh_feature       = true
}