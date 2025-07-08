resource "kubernetes_namespace" "istio_ingress" {
  metadata {
    name = "istio-ingress"
    labels = {
      "istio-injection" = "enabled"
    }
  }
}

resource "helm_release" "istio_ingress" {
  name       = "istio-ingress"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = "istio-ingress"
  version    = var.istio_version

  create_namespace = false
  wait             = true
  timeout          = 300

  values = [
    yamlencode({
      service = {
        type = "NodePort"
        ports = [
          {
            port       = 80
            targetPort = 8080
            name       = "http2"
            nodePort   = var.http_nodeport
          },
          {
            port       = 443
            targetPort = 8443
            name       = "https"
            nodePort   = var.https_nodeport
          }
        ]
      }
      labels = {
        istio = "ingressgateway"
      }
    })
  ]

  depends_on = [kubernetes_namespace.istio_ingress]
}