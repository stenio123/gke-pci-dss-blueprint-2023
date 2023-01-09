# Creates projects and enable APIs
# TODO review APIs that should be enabled or not needed
/******************************************
  Host Project Creation
 *****************************************/
module "host-project-network" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"
  name              = "host-network"
  random_project_id = true
  
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account

  enable_shared_vpc_host_project = true
  #default_network_tier           = var.default_network_tier
  # Granting networkUser per
  # https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-shared-vpc#enabling_and_granting_roles
  grant_network_role = true

  activate_apis = [
    "anthosconfigmanagement.googleapis.com",
    "cloudtrace.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "gkehub.googleapis.com",
    "meshconfig.googleapis.com",
    "mesh.googleapis.com",
    "multiclusteringress.googleapis.com",
    "multiclusterservicediscovery.googleapis.com",
    "trafficdirector.googleapis.com"
  ]

}

/******************************************
  Service Project Creation - In-Scope
 *****************************************/
module "service-project-in-scope" {
  source  = "terraform-google-modules/project-factory/google//modules/svpc_service_project"
  version = "~> 14.0"

  name              = "service-in-scope"
  random_project_id = true

  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account

  shared_vpc         = module.host-project-network.project_id
  shared_vpc_subnets = tolist([local.shared_vpc_subnets["${var.region}/in-scope-subnet"].id])
  #shared_vpc_subnets = module.vpc.subnets_self_links
  # Granting networkUser per
  # https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-shared-vpc#enabling_and_granting_roles
  grant_network_role = true

  activate_apis = [
    "anthosconfigmanagement.googleapis.com",
    "cloudtrace.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "gkehub.googleapis.com",
    "meshconfig.googleapis.com",
    "mesh.googleapis.com",
    "multiclusteringress.googleapis.com",
    "multiclusterservicediscovery.googleapis.com",
    "trafficdirector.googleapis.com"
  ]

  disable_services_on_destroy = true
}

/******************************************
  Service Project Creation - Out-of-Scope
 *****************************************/
module "out-of-scope" {
  source  = "terraform-google-modules/project-factory/google//modules/svpc_service_project"
  version = "~> 14.0"

  name              = "service-out-of-scope"
  random_project_id = true

  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account

  shared_vpc = module.host-project-network.project_id
  shared_vpc_subnets = tolist([local.shared_vpc_subnets["${var.region}/out-of-scope-subnet"].id])
  # Granting networkUser per
  # https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-shared-vpc#enabling_and_granting_roles
  grant_network_role = true

  activate_apis = [
    "anthosconfigmanagement.googleapis.com",
    "cloudtrace.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "gkehub.googleapis.com",
    "meshconfig.googleapis.com",
    "mesh.googleapis.com",
    "multiclusteringress.googleapis.com",
    "multiclusterservicediscovery.googleapis.com",
    "trafficdirector.googleapis.com"
  ]

  disable_services_on_destroy = true
}