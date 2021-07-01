module "gke" {
  source = "./modules/gke"

  cluster_name = "tf-main"
}

module "gcs-storage" {
  source = "./modules/gcs"

  name = "face-finder-storage"
}

module "gsd" {
  source = "./modules/gsd"

  network = module.gke.self_link
}
