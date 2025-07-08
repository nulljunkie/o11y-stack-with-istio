module "infra" {
  source = "./modules/infra"

  namespace                = var.namespace
  postgres_database        = var.postgres_database
  postgres_username        = var.postgres_username
  postgres_password        = var.postgres_password
  postgres_init_sql_file   = var.postgres_init_sql_file
}

module "apps" {
  source = "./modules/apps"

  namespace         = var.namespace
  server_image      = var.server_image
  server_port       = var.server_port
  client_image      = var.client_image
  postgres_host     = module.infra.postgres_service_name
  postgres_port     = module.infra.postgres_service_port
  postgres_database = var.postgres_database
  postgres_username = var.postgres_username
  postgres_password = var.postgres_password

  depends_on = [module.infra]
}
