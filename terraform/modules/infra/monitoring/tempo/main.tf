resource "helm_release" "tempo" {
  name       = "tempo"
  repository = var.chart_repository
  chart      = var.chart_name
  namespace  = var.monitoring_namespace
  version    = var.chart_version

  values = [
    yamlencode({
      fullnameOverride = "tempo"
    })
  ]
}