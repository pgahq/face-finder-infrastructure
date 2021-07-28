resource "google_redis_instance" "redis" {
  name           = "redis"
  tier           = "BASIC"
  memory_size_gb = 1

  region = var.region

  authorized_network = var.authorized_network

  redis_version = "REDIS_5_0"
}

