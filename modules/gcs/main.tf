resource "google_storage_bucket" "storage" {
  name               = var.name
  location           = var.location
  storage_class      = "REGIONAL"
  bucket_policy_only = true
}
