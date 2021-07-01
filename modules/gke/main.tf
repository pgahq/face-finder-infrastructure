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
  name     = var.cluster_name
  location = var.zone

  enable_autopilot = true

  vertical_pod_autoscaling {
    enabled = true
  }

  release_channel {
    channel = "REGULAR"
  }
  network    = google_compute_subnetwork.pgahq.name
  subnetwork = google_compute_subnetwork.pgahq.name

  resource_labels = {}
}
