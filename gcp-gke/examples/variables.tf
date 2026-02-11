variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "izz-gke-cluster"
}

variable "region" {
  description = "The GCP region for the cluster"
  type        = string
  default     = "us-central1"
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the cluster"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels to apply to cluster resources"
  type        = map(string)
  default = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
