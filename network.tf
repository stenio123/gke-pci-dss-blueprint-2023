/******************************************
  Network Creation
 *****************************************/
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id                             = module.host-project-network.project_id
  network_name                           = "pci-shared-vpc"

  subnets = [
    {
      subnet_name   = "in-scope-subnet"
      subnet_ip     = "10.0.4.0/22"
      subnet_region = var.region
      # Whether the subnets will have access to Google API's without a public IP
      subnet_private_access = true
    },
    {
      subnet_name           = "out-of-scope-subnet"
      subnet_ip             = "172.16.4.0/22"
      subnet_region         = var.region
      subnet_private_access = true
    },
    {
      # Currently not being used
      subnet_name           = "management-subnet"
      subnet_ip             = "10.10.1.0/24"
      subnet_region         = var.region
      subnet_private_access = true
    },
  ]

  secondary_ranges = {
    "in-scope-subnet" = [
      {
        range_name    = "in-scope-pods"
        ip_cidr_range = "10.4.0.0/14"
      },
      {
        range_name    = "in-scope-services"
        ip_cidr_range = "10.0.32.0/20"
      }
    ]

    "out-of-scope-subnet" = [
      {
        range_name    = "out-of-scope-pods"
        ip_cidr_range = "172.20.0.0/14"
      },
      {
        range_name    = "out-of-scope-services"
        ip_cidr_range = "172.16.16.0/20"
      }
    ]
  }
}


 locals {
    shared_vpc_subnets = module.vpc.subnets
    #[0] = in-scope
    #[1] = out-of-scope
    #[2] = management
 }