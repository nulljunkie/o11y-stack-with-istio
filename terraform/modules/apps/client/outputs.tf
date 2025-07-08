output "service_name" {
  description = "Client service name"
  value       = kubernetes_service.client.metadata[0].name
}

output "service_port" {
  description = "Client service port"
  value       = kubernetes_service.client.spec[0].port[0].port
}

output "node_port" {
  description = "Client NodePort"
  value       = kubernetes_service.client.spec[0].port[0].node_port
}