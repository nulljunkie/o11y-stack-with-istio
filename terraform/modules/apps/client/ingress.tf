resource "kubernetes_manifest" "client_gateway" {
  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind       = "Gateway"
    metadata = {
      name      = "client-gateway"
      namespace = var.namespace
    }
    spec = {
      selector = {
        istio = "ingressgateway"
      }
      servers = [
        {
          port = {
            number   = 80
            name     = "http"
            protocol = "HTTP"
          }
          hosts = ["*"]
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "client_virtual_service" {
  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind       = "VirtualService"
    metadata = {
      name      = "client-virtualservice"
      namespace = var.namespace
    }
    spec = {
      hosts = ["*"]
      gateways = ["client-gateway"]
      http = [
        {
          match = [
            {
              prefix = "/"
            }
          ]
          route = [
            {
              destination = {
                host = "client-service"
                port = {
                  number = 80
                }
              }
            }
          ]
        }
      ]
    }
  }
}