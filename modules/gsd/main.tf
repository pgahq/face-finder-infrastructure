resource "random_id" "name_suffix" {
  byte_length = 5
}

resource "google_sql_database_instance" "pgahq" {
  name             = "pgahq-instance-${random_id.name_suffix.hex}"
  database_version = var.db_version
  region           = var.region

  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]

  settings {
    tier = var.db_tier
    ip_configuration {
      ipv4_enabled    = false
      require_ssl     = false
      private_network = var.network
    }
    database_flags {
      name  = "pg_stat_statements.track"
      value = "all"
    }
    database_flags {
      name  = "pg_stat_statements.max"
      value = "10000"
    }
    database_flags {
      name  = "track_activity_query_size"
      value = "2048"
    }
  }
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = var.network
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network = var.network
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private_ip_address.name
  ]
}

resource "google_sql_user" "user" {
  name     = var.sql_root_user_name
  instance = google_sql_database_instance.pgahq.name
  password = var.sql_root_user_pw
}

resource "google_sql_database" "sceptile" {
  instance = google_sql_database_instance.pgahq.name
  name     = "face-finder"
}
