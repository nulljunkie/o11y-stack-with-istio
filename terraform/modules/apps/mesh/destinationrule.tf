resource "kubernetes_manifest" "client_destination_rule" {
  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind       = "DestinationRule"
    metadata = {
      name      = "client-destination-rule"
      namespace = var.namespace
    }
    spec = {
      host = var.client_service_fqdn
      subsets = [
        {
          name = "v1"
          labels = {
            version = "v1"
          }
        },
        {
          name = "v2"
          labels = {
            version = "v2"
          }
        }
      ]
    }
  }
}