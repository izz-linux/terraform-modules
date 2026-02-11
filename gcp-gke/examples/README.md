# GKE Cluster Example

This example demonstrates how to deploy a basic GKE cluster using the `gcp-gke` module.

## Prerequisites

- Terraform >= 1.3.0
- Google Cloud SDK (`gcloud`) installed and configured
- A GCP project with billing enabled
- Required APIs enabled:
  - Kubernetes Engine API (`container.googleapis.com`)
  - Compute Engine API (`compute.googleapis.com`)

## Enable Required APIs

```bash
gcloud services enable container.googleapis.com compute.googleapis.com
```

## Usage

1. **Authenticate with GCP:**

   ```bash
   gcloud auth application-default login
   ```

2. **Configure variables:**

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

   Edit `terraform.tfvars` with your project ID and desired configuration.

3. **Initialize Terraform:**

   ```bash
   terraform init
   ```

4. **Review the execution plan:**

   ```bash
   terraform plan
   ```

5. **Apply the configuration:**

   ```bash
   terraform apply
   ```

6. **Configure kubectl:**

   After the cluster is created, configure kubectl to connect:

   ```bash
   gcloud container clusters get-credentials <cluster-name> --region <region> --project <project-id>
   ```

   Or use the output command:

   ```bash
   $(terraform output -raw get_credentials_command)
   ```

7. **Verify the cluster:**

   ```bash
   kubectl get nodes
   kubectl cluster-info
   ```

## Cleanup

To destroy the cluster:

```bash
terraform destroy
```

## Notes

- This example creates a cluster in the default VPC network
- Deletion protection is disabled for easy cleanup (enable in production)
- Workload Identity is enabled for secure workload authentication
- The cluster uses the REGULAR release channel for automatic upgrades
