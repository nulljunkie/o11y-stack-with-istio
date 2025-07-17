output "tempo_service_name" {
  description = "Name of the Tempo service"
  value       = "tempo"
}

output "tempo_query_port" {
  description = "Port of the Tempo query service"
  value       = 3200
}

output "tempo_jaeger_grpc_port" {
  description = "Port for Jaeger gRPC traces"
  value       = 14250
}

output "tempo_jaeger_http_port" {
  description = "Port for Jaeger HTTP traces"
  value       = 14268
}