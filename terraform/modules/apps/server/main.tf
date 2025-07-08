resource "kubernetes_deployment" "server" {
  metadata {
    name      = "server"
    namespace = var.namespace
    labels = {
      app = "server"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "server"
      }
    }

    template {
      metadata {
        labels = {
          app = "server"
        }
      }

      spec {
        container {
          image             = var.app_image
          image_pull_policy = "IfNotPresent"
          name              = "server"

          port {
            container_port = 50051
          }

          env {
            name  = "POSTGRES_HOST"
            value = var.postgres_host
          }

          env {
            name  = "POSTGRES_PORT"
            value = tostring(var.postgres_port)
          }

          env {
            name  = "POSTGRES_DB"
            value = var.postgres_database
          }

          env {
            name  = "POSTGRES_USER"
            value = var.postgres_username
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = var.postgres_password
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "server" {
  metadata {
    name      = "server-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "server"
    }

    port {
      port        = 50051
      target_port = 50051
    }

    type = "ClusterIP"
  }
}