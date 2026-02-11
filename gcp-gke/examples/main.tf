# Example: Basic GKE Cluster

module "gke" {
  source = "../"

  cluster_name = var.cluster_name
  project_id   = var.project_id
  region       = var.region

  kubernetes_version = var.kubernetes_version
  release_channel    = "REGULAR"

  # Use default VPC network
  network    = "default"
  subnetwork = "default"

  # Default node pool configuration
  default_node_pool = {
    name         = "default"
    machine_type = "e2-standard-2"
    node_count   = 2
    disk_size_gb = 50
    disk_type    = "pd-standard"
  }

  # Enable Workload Identity (recommended for production)
  workload_identity_config = var.project_id

  # Enable recommended security features
  enable_shielded_nodes = true

  # Disable deletion protection for example (enable in production)
  deletion_protection = false

  labels = var.labels

  resource_labels = {
    environment = "example"
    managed_by  = "terraform"
  }
}
