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
      version = "2.3.2"
    }
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
  host                   = module.gke.endpoint
  token                  = module.gke.google_client_config.access_token
  client_certificate     = base64decode(module.gke.master_auth.0.client_certificate)
  client_key             = base64decode(module.gke.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(module.gke.master_auth.0.cluster_ca_certificate)
}
