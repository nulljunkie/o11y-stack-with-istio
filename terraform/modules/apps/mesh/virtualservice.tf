resource "kubernetes_manifest" "quote_client_vs" {
  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind       = "VirtualService"
    metadata = {
      name      = "quote-client-vs"
      namespace = var.namespace
    }
    spec = {
      hosts = ["*"]
      gateways = ["quote-gateway"]
      http = [
        {
          match = [
            {
              uri = {
                exact = "/health"
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
              }
            }
          ]
          timeout = "2s"
          retries = {
            attempts      = 2
            perTryTimeout = "1s"
          }
        },
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
          timeout = "10s"
          retries = {
            attempts      = 3
            perTryTimeout = "3s"
          }
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
          timeout = "10s"
          retries = {
            attempts      = 3
            perTryTimeout = "3s"
          }
        }
      ]
    }
  }
}
