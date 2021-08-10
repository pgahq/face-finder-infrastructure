terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.74.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.4.1"
    }
  }

  backend "gcs" {
    bucket      = "face-finder-tf-state"
    credentials = "credentials.json"
  }
}

provider "google" {
  region      = var.region
  credentials = file("credentials.json")
  project     = var.project_id
}

provider "helm" {
  kubernetes {
    host                   = module.gke.endpoint
    token                  = module.gke.google_client_config.access_token
    client_certificate     = base64decode(module.gke.master_auth.0.client_certificate)
    client_key             = base64decode(module.gke.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(module.gke.master_auth.0.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  username               = module.gke.username
  host                   = "https://${module.gke.endpoint}"
  token                  = module.gke.google_client_config.access_token
  client_certificate     = base64decode(module.gke.master_auth.0.client_certificate)
  client_key             = base64decode(module.gke.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(module.gke.master_auth.0.cluster_ca_certificate)

  experiments {
    manifest_resource = true
  }
}
