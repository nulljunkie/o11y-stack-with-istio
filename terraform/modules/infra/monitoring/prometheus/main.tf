resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.monitoring_namespace
    labels = {
      "istio-injection" = "enabled"
    }
  }
}

resource "helm_release" "kube_prometheus" {
  name       = "kube-prometheus"
  repository = var.chart_repository
  chart      = var.chart_name
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = var.chart_version

  values = [
    yamlencode({
      fullnameOverride = "kube-prometheus"
      
      prometheus = {
        additionalScrapeConfigs = {
          enabled = true
          type    = "internal"
          internal = {
            jobList = [
              {
                job_name = "istiod"
                kubernetes_sd_configs = [
                  {
                    role = "endpoints"
                    namespaces = {
                      names = ["istio-system"]
                    }
                  }
                ]
                relabel_configs = [
                  {
                    source_labels = ["__meta_kubernetes_service_name", "__meta_kubernetes_endpoint_port_name"]
                    action = "keep"
                    regex = "istiod;http-monitoring"
                  }
                ]
              },
              {
                job_name = "envoy-stats"
                kubernetes_sd_configs = [
                  {
                    role = "pod"
                  }
                ]
                relabel_configs = [
                  {
                    source_labels = ["__meta_kubernetes_pod_container_name", "__meta_kubernetes_pod_annotationpresent_prometheus_io_scrape"]
                    action = "keep"
                    regex = "istio-proxy;true"
                  },
                  {
                    source_labels = ["__address__", "__meta_kubernetes_pod_annotation_prometheus_io_port"]
                    action = "replace"
                    regex = "([^:]+)(?:\\\\d+)?;(\\\\d+)"
                    replacement = "$1:15090"
                    target_label = "__address__"
                  },
                  {
                    action = "labelmap"
                    regex = "__meta_kubernetes_pod_label_(.+)"
                  },
                  {
                    source_labels = ["__meta_kubernetes_namespace"]
                    action = "replace"
                    target_label = "namespace"
                  },
                  {
                    source_labels = ["__meta_kubernetes_pod_name"]
                    action = "replace"
                    target_label = "pod_name"
                  }
                ]
                metrics_path = "/stats/prometheus"
              }
            ]
          }
        }
      }
      
      alertmanager = {
        enabled = true
      }
    })
  ]

  depends_on = [kubernetes_namespace.monitoring]
}