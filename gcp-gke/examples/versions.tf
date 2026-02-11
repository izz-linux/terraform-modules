terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0, < 7.0.0"
    }
  }

  # Backend configuration for GCS state storage
  # Uncomment and configure for remote state management
  backend "gcs" {
    bucket = "izz-tf"
    prefix = "gke/izz-cluster"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
