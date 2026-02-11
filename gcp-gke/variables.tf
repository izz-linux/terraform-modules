variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID where the cluster will be created"
  type        = string
}

variable "region" {
  description = "The GCP region for the cluster (e.g., us-central1)"
  type        = string
}

variable "zones" {
  description = "The zones within the region for node placement. If not specified, GKE will automatically select zones"
  type        = list(string)
  default     = null
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the cluster. If not specified, the default version will be used"
  type        = string
  default     = null
}

variable "release_channel" {
  description = "The release channel for the cluster. Valid values are UNSPECIFIED, RAPID, REGULAR, or STABLE"
  type        = string
  default     = "REGULAR"

  validation {
    condition     = contains(["UNSPECIFIED", "RAPID", "REGULAR", "STABLE"], var.release_channel)
    error_message = "release_channel must be one of: UNSPECIFIED, RAPID, REGULAR, or STABLE."
  }
}

variable "network" {
  description = "The VPC network to host the cluster in"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  type        = string
  default     = "default"
}

variable "default_node_pool" {
  description = "Configuration for the default node pool"
  type = object({
    name               = optional(string, "default")
    machine_type       = optional(string, "e2-medium")
    node_count         = optional(number, 1)
    auto_scaling       = optional(bool, false)
    min_count          = optional(number, null)
    max_count          = optional(number, null)
    disk_size_gb       = optional(number, 100)
    disk_type          = optional(string, "pd-standard")
    image_type         = optional(string, "COS_CONTAINERD")
    preemptible        = optional(bool, false)
    spot               = optional(bool, false)
    service_account    = optional(string, null)
    oauth_scopes       = optional(list(string), ["https://www.googleapis.com/auth/cloud-platform"])
    node_locations     = optional(list(string), null)
    max_pods_per_node  = optional(number, null)
  })
  default = {}

  validation {
    condition = (
      !var.default_node_pool.auto_scaling ||
      (var.default_node_pool.min_count != null && var.default_node_pool.max_count != null && var.default_node_pool.max_count >= var.default_node_pool.min_count)
    )
    error_message = "When auto_scaling is enabled, min_count and max_count must be set and max_count must be greater than or equal to min_count."
  }

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,39}$", var.default_node_pool.name))
    error_message = "Node pool name must start with a lowercase letter, contain only lowercase letters, numbers, and hyphens, and be at most 40 characters."
  }

  validation {
    condition     = !(var.default_node_pool.preemptible && var.default_node_pool.spot)
    error_message = "Cannot specify both preemptible and spot. Choose one or neither."
  }
}

variable "private_cluster_config" {
  description = "Configuration for private cluster"
  type = object({
    enable_private_nodes    = optional(bool, false)
    enable_private_endpoint = optional(bool, false)
    master_ipv4_cidr_block  = optional(string, null)
  })
  default = null

  validation {
    condition = (
      var.private_cluster_config == null ||
      !var.private_cluster_config.enable_private_nodes ||
      var.private_cluster_config.master_ipv4_cidr_block != null
    )
    error_message = "When enable_private_nodes is true, master_ipv4_cidr_block must be specified."
  }
}

variable "master_authorized_networks" {
  description = "List of CIDR blocks authorized to access the cluster master endpoint"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = null
}

variable "ip_allocation_policy" {
  description = "Configuration for cluster IP allocation (VPC-native cluster)"
  type = object({
    cluster_secondary_range_name  = optional(string, null)
    services_secondary_range_name = optional(string, null)
    cluster_ipv4_cidr_block       = optional(string, null)
    services_ipv4_cidr_block      = optional(string, null)
  })
  default = null
}

variable "workload_identity_config" {
  description = "Configuration for Workload Identity. Set to project_id to enable"
  type        = string
  default     = null
}

variable "enable_binary_authorization" {
  description = "Enable Binary Authorization for the cluster"
  type        = bool
  default     = false
}

variable "enable_network_policy" {
  description = "Enable network policy enforcement"
  type        = bool
  default     = false
}

variable "enable_vertical_pod_autoscaling" {
  description = "Enable Vertical Pod Autoscaling"
  type        = bool
  default     = false
}

variable "enable_shielded_nodes" {
  description = "Enable Shielded GKE Nodes"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection for the cluster"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to apply to the cluster"
  type        = map(string)
  default     = {}
}

variable "resource_labels" {
  description = "Resource labels to apply to the GKE cluster resource"
  type        = map(string)
  default     = {}
}
