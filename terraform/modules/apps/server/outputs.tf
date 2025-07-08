output "service_name" {
  description = "Server service name"
  value       = kubernetes_service.server.metadata[0].name
}

output "service_port" {
  description = "Server service port"
  value       = kubernetes_service.server.spec[0].port[0].port
}