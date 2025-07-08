output "gateway_service_name" {
  description = "Istio ingress gateway service name"
  value       = "istio-ingress"
}

output "gateway_namespace" {
  description = "Istio ingress gateway namespace"
  value       = kubernetes_namespace.istio_ingress.metadata[0].name
}

output "http_nodeport" {
  description = "HTTP NodePort"
  value       = var.http_nodeport
}

output "https_nodeport" {
  description = "HTTPS NodePort"
  value       = var.https_nodeport
}