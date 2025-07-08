module "postgres" {
  source = "./postgres"

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