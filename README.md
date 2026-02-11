# Terraform Modules

Multi-cloud Terraform modules for infrastructure deployment.

## Available Modules

| Cloud | Module | Description |
|-------|--------|-------------|
| Azure | [azure-aks](./azure-aks) | Azure Kubernetes Service (AKS) |
| GCP | [gcp-gke](./gcp-gke) | Google Kubernetes Engine (GKE) |
| AWS | Coming soon | Amazon Elastic Kubernetes Service (EKS) |

## Usage

Each module has its own directory with Terraform files and examples.

### Azure AKS

```hcl
module "aks" {
  source = "github.com/izz-linux/terraform-modules//azure-aks"

  cluster_name        = "my-aks-cluster"
  resource_group_name = "my-resource-group"
  location            = "eastus"

  default_node_pool = {
    vm_size    = "Standard_D2s_v3"
    node_count = 3
  }
}
```

### GCP GKE

```hcl
module "gke" {
  source = "github.com/izz-linux/terraform-modules//gcp-gke"

  cluster_name = "my-gke-cluster"
  project_id   = "my-gcp-project"
  region       = "us-central1"

  default_node_pool = {
    machine_type = "e2-standard-2"
    node_count   = 3
  }
}
```

See individual module READMEs for detailed usage instructions.

## License

See [LICENSE](./LICENSE) for details.
