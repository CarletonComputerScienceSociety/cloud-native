job "s3" {
  datacenters = ["scs"]

  group "minio" {
    ephemeral_disk {
      migrate = true
      size    = "5000"
      sticky  = true
    }

    network {
      port "http" {
        to = 9000
      }
    }

    task "minio" {
      driver = "docker"

      config {
        image = "minio/minio"

        volumes = [
          "local/export:/export",
        ]

        args = [
          "server",
          "/export",
        ]

        ports = ["http"]
      }

      env {
        MINIO_ROOT_USER = "admin"
        MINIO_ROOT_PASSWORD = "AnejPq958Ha6FVSg9tGT5ZcBz34"
        MINIO_BROWSER_REDIRECT_URI = "grafana.discretemath.ca"
      }

      service {
        name = "minio"

        tags = [
          "s3",
          "minio",
          "traefik.enable=true",
          "traefik.http.routers.http.rule=Host(`grafana.discretemath.ca`)",
        ]

        port = "http"

        check {
          type     = "http"
          path     = "/minio/health/live"
          port     = "http"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 500
        memory = 1024
      }
    }
  }
}