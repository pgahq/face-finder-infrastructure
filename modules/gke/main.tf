resource "google_compute_network" "pgahq" {
  name                    = var.cluster_name
  auto_create_subnetworks = false
}

resource "google_compute_address" "pgahq" {
  name   = var.cluster_name
  region = var.region
}

resource "google_compute_subnetwork" "pgahq" {
  name                     = var.cluster_name
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.pgahq.self_link
  region                   = var.region
  private_ip_google_access = true
}

data "google_client_config" "current" {}

data "google_container_engine_versions" "pgahq" {
  location = var.zone
}

resource "google_container_cluster" "pgahq" {
  name                     = var.cluster_name
  location                 = var.zone
  initial_node_count       = 2
  remove_default_node_pool = true

  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum       = 2
      maximum       = 20
    }
    resource_limits {
      resource_type = "memory"
      minimum       = 4
      maximum       = 40
    }
  }

  min_master_version = data.google_container_engine_versions.pgahq.latest_master_version
  network            = google_compute_subnetwork.pgahq.name
  subnetwork         = google_compute_subnetwork.pgahq.name

  network_policy {
    enabled = true
    # CALICO is currently the only supported provider
    provider = "CALICO"
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
}
