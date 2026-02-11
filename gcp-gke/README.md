# GCP GKE Terraform Module

This module creates a Google Kubernetes Engine (GKE) cluster with a configurable default node pool.

## Features

- Configurable default node pool with optional autoscaling
- Support for private clusters with private nodes and endpoints
- Master authorized networks for enhanced security
- Workload Identity support for secure workload authentication
- VPC-native cluster with configurable IP allocation
- Network policy enforcement with Calico
- Binary Authorization support
- Vertical Pod Autoscaling
- Shielded GKE Nodes for enhanced security
- Preemptible and Spot VM support for cost optimization
- Flexible release channel configuration

## Usage

```hcl
module "gke" {
  source = "github.com/izz-linux/terraform-modules//gcp-gke?ref=v0.2.0"

  cluster_name = "my-gke-cluster"
  project_id   = "my-gcp-project"
  region       = "us-central1"

  default_node_pool = {
    machine_type = "e2-standard-2"
    node_count   = 3
  }

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| google | >= 5.0.0, < 7.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | The name of the GKE cluster | `string` | n/a | yes |
| project_id | The GCP project ID where the cluster will be created | `string` | n/a | yes |
| region | The GCP region for the cluster | `string` | n/a | yes |
| zones | The zones within the region for node placement | `list(string)` | `null` | no |
| kubernetes_version | The Kubernetes version for the cluster | `string` | `null` | no |
| release_channel | The release channel (UNSPECIFIED, RAPID, REGULAR, STABLE) | `string` | `"REGULAR"` | no |
| network | The VPC network to host the cluster in | `string` | `"default"` | no |
| subnetwork | The subnetwork to host the cluster in | `string` | `"default"` | no |
| default_node_pool | Configuration for the default node pool | `object` | `{}` | no |
| private_cluster_config | Configuration for private cluster | `object` | `null` | no |
| master_authorized_networks | List of CIDR blocks authorized to access master | `list(object)` | `null` | no |
| ip_allocation_policy | Configuration for cluster IP allocation | `object` | `null` | no |
| workload_identity_config | Project ID for Workload Identity (enables WI when set) | `string` | `null` | no |
| enable_binary_authorization | Enable Binary Authorization | `bool` | `false` | no |
| enable_network_policy | Enable network policy enforcement | `bool` | `false` | no |
| enable_vertical_pod_autoscaling | Enable Vertical Pod Autoscaling | `bool` | `false` | no |
| enable_shielded_nodes | Enable Shielded GKE Nodes | `bool` | `true` | no |
| deletion_protection | Enable deletion protection for the cluster | `bool` | `true` | no |
| labels | Labels to apply to the cluster nodes | `map(string)` | `{}` | no |
| resource_labels | Resource labels to apply to the GKE cluster | `map(string)` | `{}` | no |

### Default Node Pool Configuration

| Attribute | Description | Type | Default |
|-----------|-------------|------|---------|
| name | Name of the node pool | `string` | `"default"` |
| machine_type | GCE machine type | `string` | `"e2-medium"` |
| node_count | Number of nodes (when autoscaling disabled) | `number` | `1` |
| auto_scaling | Enable autoscaling | `bool` | `false` |
| min_count | Minimum nodes (when autoscaling enabled) | `number` | `null` |
| max_count | Maximum nodes (when autoscaling enabled) | `number` | `null` |
| disk_size_gb | Disk size in GB | `number` | `100` |
| disk_type | Disk type (pd-standard, pd-ssd, pd-balanced) | `string` | `"pd-standard"` |
| image_type | Node image type | `string` | `"COS_CONTAINERD"` |
| preemptible | Use preemptible VMs | `bool` | `false` |
| spot | Use Spot VMs | `bool` | `false` |
| service_account | Service account for nodes | `string` | `null` |
| oauth_scopes | OAuth scopes for nodes | `list(string)` | `["https://www.googleapis.com/auth/cloud-platform"]` |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| cluster_id | The unique identifier of the GKE cluster | no |
| cluster_name | The name of the GKE cluster | no |
| cluster_self_link | The self link of the GKE cluster | no |
| cluster_endpoint | The IP address of the cluster master endpoint | yes |
| cluster_ca_certificate | The public certificate of the cluster's CA | yes |
| cluster_location | The location of the cluster | no |
| cluster_master_version | The current version of the master | no |
| node_pool_name | The name of the default node pool | no |
| node_pool_instance_group_urls | The URLs of the managed instance groups | no |
| service_account | The service account used by the node pool | no |
| workload_identity_pool | The Workload Identity pool if enabled | no |
| network | The VPC network hosting the cluster | no |
| subnetwork | The subnetwork hosting the cluster | no |

## Examples

See the [examples](./examples/) directory for complete usage examples.

## License

See [LICENSE](../LICENSE) for full details.
