resource "kubernetes_deployment" "client" {
  metadata {
    name      = "client"
    namespace = var.namespace
    labels = {
      app = "client"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "client"
      }
    }

    template {
      metadata {
        labels = {
          app = "client"
        }
      }

      spec {
        container {
          image             = var.client_image
          image_pull_policy = "IfNotPresent"
          name              = "client"

          port {
            container_port = 8080
          }

          env {
            name  = "SERVER_HOST"
            value = var.server_service_name
          }

          env {
            name  = "SERVER_PORT"
            value = tostring(var.server_service_port)
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "client" {
  metadata {
    name      = "client-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "client"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "NodePort"
  }
}