job "s3" {
  datacenters = ["scs"]

  group "minio" {
    network {
      port "http" {
        to = 9000
      }
      port "console" {
        to = 9001
      }
    }

    volume "minio" {
      type      = "host"
      read_only = false
      source    = "minio"
    }

    task "minio" {
      driver = "docker"

      volume_mount {
        volume      = "minio"
        destination = "/export"
        read_only   = false
      }

      config {
        image = "minio/minio"

        args = [
          "server",
          "/export",
          "--console-address=:9001",
        ]

        ports = ["http", "console"]
      }

      env {
        MINIO_ROOT_USER            = "admin"
        // MINIO_ROOT_PASSWORD        = "password" # Change this to the actual password
        MINIO_BROWSER_REDIRECT_URI = "console.minio.discretemath.ca"
        MINIO_SERVER_URL           = "https://minio.discretemath.ca"
      }

      service {
        name = "minio-server"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.minio-router.rule=Host(`minio.discretemath.ca`)",
          "traefik.http.routers.minio-router.entrypoints=https",
          "traefik.http.routers.minio-router.tls.certresolver=letsencrypt"
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
          "traefik.http.routers.minio-console-router.entrypoints=https",
          "traefik.http.routers.minio-console-router.tls.certresolver=letsencrypt"
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