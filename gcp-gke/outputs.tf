output "cluster_id" {
  description = "The unique identifier of the GKE cluster"
  value       = google_container_cluster.this.id
}

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.this.name
}

output "cluster_self_link" {
  description = "The self link of the GKE cluster"
  value       = google_container_cluster.this.self_link
}

output "cluster_endpoint" {
  description = "The IP address of the cluster master endpoint"
  value       = google_container_cluster.this.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The public certificate of the cluster's certificate authority (base64-encoded)"
  value       = google_container_cluster.this.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_location" {
  description = "The location (region or zone) of the cluster"
  value       = google_container_cluster.this.location
}

output "cluster_master_version" {
  description = "The current version of the master in the cluster"
  value       = google_container_cluster.this.master_version
}

output "node_pool_name" {
  description = "The name of the default node pool"
  value       = google_container_node_pool.default.name
}

output "node_pool_instance_group_urls" {
  description = "The URLs of the managed instance groups created by the node pool"
  value       = google_container_node_pool.default.managed_instance_group_urls
}

output "service_account" {
  description = "The service account used by the node pool"
  value       = google_container_node_pool.default.node_config[0].service_account
}

output "workload_identity_pool" {
  description = "The Workload Identity pool if enabled"
  value       = try(google_container_cluster.this.workload_identity_config[0].workload_pool, null)
}

output "network" {
  description = "The VPC network hosting the cluster"
  value       = google_container_cluster.this.network
}

output "subnetwork" {
  description = "The subnetwork hosting the cluster"
  value       = google_container_cluster.this.subnetwork
}
