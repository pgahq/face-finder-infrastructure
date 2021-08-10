resource "kubernetes_manifest" "lets-encrypt-issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind = "Issuer"

    metadata = {
      name = "lets-encrypt"
      namespace = "default"
    }

    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email = "devops@pga.com"
        privateKeySecretRef = {
          name = "lets-encrypt"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          }]
      }
    }
  }
}

resource "kubernetes_manifest" "lets-encrypt-staging-issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind = "Issuer"

    metadata = {
      name = "lets-encrypt-staging"
      namespace = "default"
    }

    spec = {
      acme = {
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"
        email = "devops@pga.com"
        privateKeySecretRef = {
          name = "lets-encrypt-staging"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          }]
      }
    }
  }
}

resource "kubernetes_manifest" "facefinder-certificate" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind = "Certificate"

    metadata = {
      name = "facefinder"
      namespace = "default"
    }

    spec = {
      secretName = "facefinder-tls"
      issuerRef = {
        name = "lets-encrypt"
      }
      commonName = "pgahq.com"
      dnsNames = [
        "static.facefinder.dev.pga.com",
        "facefinder.dev.pga.com"
      ]
    }
  }
}
