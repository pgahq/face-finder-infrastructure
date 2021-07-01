output "address" {
  value = google_compute_address.pgahq.address
}

output "self_link" {
  value = google_compute_network.pgahq.self_link
}

output "endpoint" {
  value = google_container_cluster.pgahq.endpoint
}

output "master_auth" {
  value = google_container_cluster.pgahq.master_auth
}

output "google_client_config" {
  value = data.google_client_config.current
}

output "username" {
  value = google_container_cluster.pgahq.master_auth[0].username
}
