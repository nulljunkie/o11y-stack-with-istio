resource "helm_release" "grafana" {
  name       = "grafana"
  repository = var.chart_repository
  chart      = var.chart_name
  namespace  = var.monitoring_namespace
  version    = var.chart_version

  values = [
    yamlencode({
      fullnameOverride = "grafana"
      
      admin = {
        user     = "admin"
        password = var.grafana_admin_password
      }
      
      service = {
        type = "NodePort"
        nodePorts = {
          grafana = var.grafana_nodeport
        }
      }
      
      datasources = {
        secretDefinition = {
          apiVersion = 1
          datasources = [
            {
              name      = "Prometheus"
              type      = "prometheus"
              url       = "http://kube-prometheus-prometheus:9090"
              access    = "proxy"
              isDefault = true
            },
            {
              name   = "Loki"
              type   = "loki"
              url    = "http://loki:3100"
              access = "proxy"
            },
            {
              name   = "Tempo"
              type   = "tempo"
              url    = "http://tempo:3200"
              access = "proxy"
            }
          ]
        }
      }
      
      dashboards = {
        default = {
          "istio-mesh-dashboard" = {
            gnetId     = 7639
            revision   = 1
            datasource = "Prometheus"
          }
          "istio-service-dashboard" = {
            gnetId     = 7636
            revision   = 1
            datasource = "Prometheus"
          }
          "istio-workload-dashboard" = {
            gnetId     = 7630
            revision   = 1
            datasource = "Prometheus"
          }
          "istio-performance-dashboard" = {
            gnetId     = 11829
            revision   = 1
            datasource = "Prometheus"
          }
        }
      }
    })
  ]
}