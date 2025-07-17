module "postgres" {
  source = "./databases/postgres"

  namespace     = var.namespace
  database      = var.postgres_database
  username      = var.postgres_username
  password      = var.postgres_password
  init_sql_file = var.postgres_init_sql_file
}

module "istio" {
  source = "./istio"

  app_namespace = var.namespace
}

module "monitoring" {
  source = "./monitoring"

  grafana_admin_password = var.grafana_admin_password
  grafana_nodeport      = var.grafana_nodeport

  depends_on = [module.istio]
}