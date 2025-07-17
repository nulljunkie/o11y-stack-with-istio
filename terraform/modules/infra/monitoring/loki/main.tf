resource "helm_release" "loki" {
  name       = "loki"
  repository = var.chart_repository
  chart      = var.chart_name
  namespace  = var.monitoring_namespace
  version    = var.chart_version

  values = [
    yamlencode({
      fullnameOverride = "loki"
      
      loki = {
        auth_enabled = false
        commonConfig = {
          replication_factor = 1
        }
        storage = {
          type = "filesystem"
        }
        schemaConfig = {
          configs = [
            {
              from = "2024-01-01"
              store = "tsdb"
              object_store = "filesystem"
              schema = "v13"
              index = {
                prefix = "index_"
                period = "24h"
              }
            }
          ]
        }
      }

      promtail = {
        enabled = true
        config = {
          serverPort = 3101
          clients = [
            {
              url = "http://loki:3100/loki/api/v1/push"
            }
          ]
          scrapeConfigs = [
            {
              job_name = "kubernetes-pods"
              kubernetes_sd_configs = [
                {
                  role = "pod"
                }
              ]
              relabel_configs = [
                {
                  source_labels = ["__meta_kubernetes_pod_annotation_prometheus_io_scrape"]
                  action = "keep"
                  regex = "true"
                },
                {
                  source_labels = ["__meta_kubernetes_pod_annotation_prometheus_io_path"]
                  action = "replace"
                  target_label = "__path__"
                  regex = "(.+)"
                },
                {
                  source_labels = ["__address__", "__meta_kubernetes_pod_annotation_prometheus_io_port"]
                  action = "replace"
                  regex = "([^:]+)(?::\\d+)?;(\\d+)"
                  replacement = "$1:$2"
                  target_label = "__address__"
                },
                {
                  action = "labelmap"
                  regex = "__meta_kubernetes_pod_label_(.+)"
                },
                {
                  source_labels = ["__meta_kubernetes_namespace"]
                  action = "replace"
                  target_label = "kubernetes_namespace"
                },
                {
                  source_labels = ["__meta_kubernetes_pod_name"]
                  action = "replace"
                  target_label = "kubernetes_pod_name"
                }
              ]
            }
          ]
        }
      }

      gateway = {
        enabled = true
        service = {
          type = "ClusterIP"
        }
      }
    })
  ]
}