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

  vertical_pod_autoscaling {
    enabled = true
  }

  release_channel {
    channel = "REGULAR"
  }
  network    = google_compute_subnetwork.pgahq.name
  subnetwork = google_compute_subnetwork.pgahq.name

  network_policy {
    enabled = true
    # CALICO is currently the only supported provider
    provider = "CALICO"
  }
  ip_allocation_policy {
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  resource_labels = {}
}

resource "google_container_node_pool" "main" {
  cluster = var.cluster_name

  location = var.zone

  node_count = 2

  autoscaling {
    max_node_count = 20
    min_node_count = 2
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = "n1-standard-2"
    disk_size_gb = 30
    disk_type    = "pd-ssd"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}
