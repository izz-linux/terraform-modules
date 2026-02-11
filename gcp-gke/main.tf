resource "google_container_cluster" "this" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.region

  node_locations = var.zones

  min_master_version = var.kubernetes_version

  network    = var.network
  subnetwork = var.subnetwork

  deletion_protection = var.deletion_protection

  # Release channel configuration
  release_channel {
    channel = var.release_channel
  }

  # Default node pool configuration
  # We remove the default node pool and manage node pools separately for more flexibility
  remove_default_node_pool = true
  initial_node_count       = 1

  # Private cluster configuration
  dynamic "private_cluster_config" {
    for_each = var.private_cluster_config != null ? [var.private_cluster_config] : []
    content {
      enable_private_nodes    = private_cluster_config.value.enable_private_nodes
      enable_private_endpoint = private_cluster_config.value.enable_private_endpoint
      master_ipv4_cidr_block  = private_cluster_config.value.master_ipv4_cidr_block
    }
  }

  # Master authorized networks
  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks != null ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  # IP allocation policy for VPC-native cluster
  dynamic "ip_allocation_policy" {
    for_each = var.ip_allocation_policy != null ? [var.ip_allocation_policy] : []
    content {
      cluster_secondary_range_name  = ip_allocation_policy.value.cluster_secondary_range_name
      services_secondary_range_name = ip_allocation_policy.value.services_secondary_range_name
      cluster_ipv4_cidr_block       = ip_allocation_policy.value.cluster_ipv4_cidr_block
      services_ipv4_cidr_block      = ip_allocation_policy.value.services_ipv4_cidr_block
    }
  }

  # Workload Identity configuration
  dynamic "workload_identity_config" {
    for_each = var.workload_identity_config != null ? [1] : []
    content {
      workload_pool = "${var.workload_identity_config}.svc.id.goog"
    }
  }

  # Binary Authorization
  dynamic "binary_authorization" {
    for_each = var.enable_binary_authorization ? [1] : []
    content {
      evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
    }
  }

  # Network policy
  network_policy {
    enabled  = var.enable_network_policy
    provider = var.enable_network_policy ? "CALICO" : "PROVIDER_UNSPECIFIED"
  }

  # Addons configuration
  addons_config {
    network_policy_config {
      disabled = !var.enable_network_policy
    }
  }

  # Vertical Pod Autoscaling
  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }

  # Shielded nodes
  enable_shielded_nodes = var.enable_shielded_nodes

  resource_labels = var.resource_labels
}

resource "google_container_node_pool" "default" {
  name     = var.default_node_pool.name
  project  = var.project_id
  location = var.region
  cluster  = google_container_cluster.this.name

  node_locations = var.default_node_pool.node_locations

  # Node count configuration
  node_count = var.default_node_pool.auto_scaling ? null : var.default_node_pool.node_count

  # Autoscaling configuration
  dynamic "autoscaling" {
    for_each = var.default_node_pool.auto_scaling ? [1] : []
    content {
      min_node_count = var.default_node_pool.min_count
      max_node_count = var.default_node_pool.max_count
    }
  }

  max_pods_per_node = var.default_node_pool.max_pods_per_node

  node_config {
    machine_type = var.default_node_pool.machine_type
    disk_size_gb = var.default_node_pool.disk_size_gb
    disk_type    = var.default_node_pool.disk_type
    image_type   = var.default_node_pool.image_type

    preemptible = var.default_node_pool.preemptible
    spot        = var.default_node_pool.spot

    service_account = var.default_node_pool.service_account
    oauth_scopes    = var.default_node_pool.oauth_scopes

    labels = var.labels

    # Shielded instance configuration
    shielded_instance_config {
      enable_secure_boot          = var.enable_shielded_nodes
      enable_integrity_monitoring = var.enable_shielded_nodes
    }

    # Workload metadata configuration for Workload Identity
    dynamic "workload_metadata_config" {
      for_each = var.workload_identity_config != null ? [1] : []
      content {
        mode = "GKE_METADATA"
      }
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
