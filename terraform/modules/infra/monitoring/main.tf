module "prometheus" {
  source = "./prometheus"

  chart_repository     = "oci://registry-1.docker.io/bitnamicharts"
  chart_name          = "kube-prometheus"
  chart_version       = "11.2.8"
  monitoring_namespace = "monitoring"
}

module "grafana" {
  source = "./grafana"

  chart_repository       = "oci://registry-1.docker.io/bitnamicharts"
  chart_name            = "grafana"
  chart_version         = "12.0.8"
  monitoring_namespace   = "monitoring"
  grafana_admin_password = var.grafana_admin_password
  grafana_nodeport      = var.grafana_nodeport
  depends_on = [module.prometheus]
}

module "loki" {
  source = "./loki"

  chart_repository     = "oci://registry-1.docker.io/bitnamicharts"
  chart_name          = "grafana-loki"
  chart_version       = "5.0.3"
  monitoring_namespace = "monitoring"
  depends_on = [module.grafana]
}

module "tempo" {
  source = "./tempo"

  chart_repository     = "oci://registry-1.docker.io/bitnamicharts"
  chart_name          = "grafana-tempo"
  chart_version       = "4.0.10"
  monitoring_namespace = "monitoring"
  depends_on = [module.grafana]
}
