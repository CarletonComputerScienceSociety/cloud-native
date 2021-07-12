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
      port "console" {
        to = 9001
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
          "--console-address=:9001",
        ]

        ports = ["http", "console"]
      }

      env {
        MINIO_ROOT_USER            = "admin"
        MINIO_ROOT_PASSWORD        = "AnejPq958Ha6FVSg9tGT5ZcBz34"
        MINIO_BROWSER_REDIRECT_URI = "console.minio.discretemath.ca"
      }

      service {
        name = "minio-server"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.minio-router.rule=Host(`minio.discretemath.ca`)",
        ]

        port = "http"

        check {
          name     = "minio check"
          type     = "http"
          path     = "/minio/health/live"
          port     = "http"
          interval = "10s"
          timeout  = "2s"
        }
      }

      service {
        name = "minio-console"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.minio-console-router.rule=Host(`console.minio.discretemath.ca`)",
        ]

        port = "console"

        check {
          name     = "minio console check"
          type     = "http"
          path     = "/dashboard"
          port     = "console"
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