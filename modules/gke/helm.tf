resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "jetstack/cert-manager"
  namespace  = "cert-manager"
}

