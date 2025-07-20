resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = var.namespace
    labels = {
      "istio-injection" = "enabled"
    }
  }
}

module "infra" {
  source = "./modules/infra"

  namespace                = var.namespace
  postgres_database        = var.postgres_database
  postgres_username        = var.postgres_username
  postgres_password        = var.postgres_password
  postgres_init_sql_file   = var.postgres_init_sql_file
  grafana_admin_password   = var.grafana_admin_password
  grafana_nodeport         = var.grafana_nodeport

  depends_on = [kubernetes_namespace.app_namespace]
}

module "apps" {
  source = "./modules/apps"

  namespace         = var.namespace
  server_image      = var.server_image
  server_port       = var.server_port
  client_v1_image   = var.client_v1_image
  client_v2_image   = var.client_v2_image
  postgres_host     = module.infra.postgres_service_name
  postgres_port     = module.infra.postgres_service_port
  postgres_database = var.postgres_database
  postgres_username = var.postgres_username
  postgres_password = var.postgres_password

  depends_on = [module.infra, kubernetes_namespace.app_namespace]
}
