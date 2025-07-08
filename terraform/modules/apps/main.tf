module "server" {
  source = "./server"

  namespace         = var.namespace
  app_image         = var.server_image
  app_port          = var.server_port
  postgres_host     = var.postgres_host
  postgres_port     = var.postgres_port
  postgres_database = var.postgres_database
  postgres_username = var.postgres_username
  postgres_password = var.postgres_password
}

module "client" {
  source = "./client"

  namespace           = var.namespace
  client_image        = var.client_image
  server_service_name = module.server.service_name
  server_service_port = module.server.service_port

  depends_on = [module.server]
}