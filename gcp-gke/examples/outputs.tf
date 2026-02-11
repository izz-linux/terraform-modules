output "cluster_id" {
  description = "The unique identifier of the GKE cluster"
  value       = module.gke.cluster_id
}

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.gke.cluster_name
}

output "cluster_endpoint" {
  description = "The IP address of the cluster master endpoint"
  value       = module.gke.cluster_endpoint
  sensitive   = true
}

output "cluster_location" {
  description = "The location of the cluster"
  value       = module.gke.cluster_location
}

output "cluster_master_version" {
  description = "The Kubernetes master version"
  value       = module.gke.cluster_master_version
}

output "get_credentials_command" {
  description = "gcloud command to get cluster credentials"
  value       = "gcloud container clusters get-credentials ${module.gke.cluster_name} --region ${module.gke.cluster_location} --project ${var.project_id}"
}
