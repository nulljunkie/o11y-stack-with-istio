resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = kubernetes_namespace.istio_system.metadata[0].name
  version    = var.istio_version

  create_namespace = false

  values = [
    yamlencode({
      defaultRevision = "default"
    })
  ]

  depends_on = [kubernetes_namespace.istio_system]
}
