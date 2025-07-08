output "server_service_name" {
  description = "Server service name"
  value       = module.server.service_name
}

output "server_service_port" {
  description = "Server service port"
  value       = module.server.service_port
}

output "client_service_name" {
  description = "Client service name"
  value       = module.client.service_name
}

output "client_service_port" {
  description = "Client service port"
  value       = module.client.service_port
}

output "client_node_port" {
  description = "Client NodePort"
  value       = module.client.node_port
}