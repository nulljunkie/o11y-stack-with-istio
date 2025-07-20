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
              headers = {
                "x-user-id" = {
                  exact = "beta-tester"
                }
              }
            }
          ]
          route = [
            {
              destination = {
                host = var.client_service_fqdn
                port = {
                  number = var.client_service_port
                }
                subset = "v2"
              }
            }
          ]
        },
        {
          match = [
            {
              prefix = "/"
            }
          ]
          route = [
            {
              destination = {
                host = var.client_service_fqdn
                port = {
                  number = var.client_service_port
                }
                subset = "v1"
              }
            }
          ]
        }
      ]
    }
  }
}