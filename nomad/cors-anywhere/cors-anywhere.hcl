job "cors-anywhere" {
  datacenters = ["scs"]

  group "cors-anywhere" {
    count = 3

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name = "cors-anywhere"
      port = "http"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.cors-anywhere.rule=Host(`cors.discretemath.ca`)",
        "traefik.http.routers.cors-anywhere.entrypoints=https",
        "traefik.http.routers.cors-anywhere.tls.certresolver=letsencrypt"
      ]

      check {
        type     = "http"
        path     = "/"
        interval = "2s"
        timeout  = "2s"

        check_restart {
          limit           = 3
          grace           = "10s"
          ignore_warnings = true
        }
      }
    }

    task "cors-anywhere" {
      driver = "docker"

      config {
        image = "redocly/cors-anywhere"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 256
      }
    }
  }
}
