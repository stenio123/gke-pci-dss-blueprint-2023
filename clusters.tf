module "gke-in-scope" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                 = module.service-project-in-scope.project_id
  name                       = "gke-in-scope"
  region                     = var.region
  network                    = module.vpc.network_name
  network_project_id         = module.host-project-network.project_id
  subnetwork                 = "in-scope-subnet"
  ip_range_pods              = "in-scope-pods"
  ip_range_services          = "in-scope-services"
  # For metrics to get displayed on the Anthos Service Mesh pages in the Cloud console
  cluster_resource_labels = { "mesh_id" : "proj-${module.service-project-in-scope.project_number}" }
  #TODO: Potentially superseeded by Istio/Anthos Service Mesh?
  #network_policy             = false
  horizontal_pod_autoscaling = true
  # Is this needed for ASM?
  identity_namespace      = "${module.service-project-in-scope.project_id}.svc.id.goog"
  # True caused issues when specifying the master_authorized networks below
  enable_private_endpoint    = false 
  enable_private_nodes       = true
  enable_shielded_nodes      = true
  remove_default_node_pool   = true
  # Reference:
  # https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/NodeConfig#nodemetadata
  node_metadata = "GKE_METADATA_SERVER"
  # TODO check
  # Reference:
  #https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks
  master_ipv4_cidr_block     = "10.10.11.0/28"
  # TODO check
  # The following is used in the original GKE PCI Blueprint https://github.com/GoogleCloudPlatform/pci-gke-blueprint/blob/a331ae8a18fdc1847e8f8cb134a6cf9a3494779e/terraform/infrastructure/shared.tf#L96
  # But causes error
  # │ Error: Error waiting for creating GKE cluster: Invalid master authorized networks: network "0.0.0.0/0" is not a reserved network, which is required for private endpoints.
  # More context: https://stackoverflow.com/questions/57548376/creating-a-private-cluster-in-gke-terraform-vs-console
  #master_authorized_networks = [
  #{
  #    cidr_block   = "0.0.0.0/0"
  #    display_name = "all"
  #}
  #]

  node_pools = [
    {
      name                      = "default-node-pool"
      machine_type              = "e2-standard-4"
      min_count                 = 1
      max_count                 = 10
      local_ssd_count           = 0
      spot                      = false
      disk_size_gb              = 100
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      auto_repair               = true
      auto_upgrade              = true
      service_account           = "project-service-account@${module.host-project-network.project_id}.iam.gserviceaccount.com"
      preemptible               = false
      initial_node_count        = 1
      enable_secure_boot = true
    },
  ]
/**
  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }*/
}