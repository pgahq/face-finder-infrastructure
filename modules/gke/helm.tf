resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  set {
    name = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "ingress-nginx" {
  chart      = "ingress-nginx"
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"

  values = [
    file("ingress-nginx-values.yaml")
  ]

  set {
    name  = "controller.service.loadBalancerIP"
    value = google_compute_address.nginx.address
  }
}
