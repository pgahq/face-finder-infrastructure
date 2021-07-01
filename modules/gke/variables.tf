variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "cluster_name" {
  description = "The name of gke cluster"
  type        = string
}
