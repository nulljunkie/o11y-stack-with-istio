resource "kubernetes_manifest" "default_telemetry" {
  manifest = {
    apiVersion = "telemetry.istio.io/v1alpha1"
    kind       = "Telemetry"
    metadata = {
      name      = "default"
      namespace = var.istio_namespace
    }
    spec = {
      metrics = [
        {
          providers = [
            {
              name = "prometheus"
            }
          ]
          overrides = [
            {
              match = {
                metric = "ALL_METRICS"
              }
              tagOverrides = {
                destination_service_name = {
                  value = "%%{destination_service_name}"
                }
                destination_service_namespace = {
                  value = "%%{destination_service_namespace}"
                }
                source_app = {
                  value = "%%{source_app}"
                }
                destination_app = {
                  value = "%%{destination_app}"
                }
              }
            }
          ]
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "envoy_access_logs" {
  manifest = {
    apiVersion = "telemetry.istio.io/v1alpha1"
    kind       = "Telemetry"
    metadata = {
      name      = "access-logs"
      namespace = var.istio_namespace
    }
    spec = {
      accessLogging = [
        {
          providers = [
            {
              name = "envoy"
            }
          ]
        }
      ]
    }
  }
}