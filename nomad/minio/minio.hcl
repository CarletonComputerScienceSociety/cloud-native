job "s3" {
  datacenters = ["SCS"]

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
        MINIO_ACCESS_KEY = "AKIAIOSFODNN7EXAMPLE"
        MINIO_SECRET_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
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
          path     = "/minio/login"
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