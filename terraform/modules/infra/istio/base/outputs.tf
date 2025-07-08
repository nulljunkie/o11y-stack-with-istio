output "namespace" {
  description = "Istio system namespace"
  value       = kubernetes_namespace.istio_system.metadata[0].name
}

output "base_release_name" {
  description = "Istio base release name"
  value       = helm_release.istio_base.name
}