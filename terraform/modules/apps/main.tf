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
  client_v1_image     = var.client_v1_image
  client_v2_image     = var.client_v2_image
  server_service_name = module.server.service_name
  server_service_port = module.server.service_port

  depends_on = [module.server]
}

module "mesh" {
  source = "./mesh"

  namespace            = var.namespace
  client_service_fqdn  = "${module.client.service_name}.${var.namespace}.svc.cluster.local"
  server_service_fqdn  = "${module.server.service_name}.${var.namespace}.svc.cluster.local"
  client_service_port  = module.client.service_port

  depends_on = [module.client, module.server]
}
