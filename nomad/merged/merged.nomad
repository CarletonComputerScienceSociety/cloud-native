job "merged-staging" {
  datacenters = ["scs"]

  group "client" {
    network {
      port "frontend" {
        to = 3000
      }
    }

    service {
      name = "merged-nextjs-staging"
      port = "frontend"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.merged-nextjs-staging.rule=Host(`merged.staging.discretemath.ca`)",
        "traefik.http.routers.merged-nextjs-staging.entrypoints=https",
        "traefik.http.routers.merged-nextjs-staging.tls.certresolver=letsencrypt"
      ]

      check {
        type     = "http"
        port     = "frontend"
        path     = "/"
        interval = "5s"
        timeout  = "2s"

        check_restart {
          limit           = 3
          grace           = "30s"
          ignore_warnings = false
        }
      }
    }

    task "nextjs" {
      driver = "docker"

      config {
        image = "ghcr.io/carletoncomputersciencesociety/merged/merged-client:latest"
        ports = ["frontend"]
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }

  group "backend" {
    network {
      mode = "bridge"

      port "api" {
        to = 8000
      }
    }

    service {
      name = "merged-django-staging"
      port = "api"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.merged-django-staging.rule=Host(`api.merged.staging.discretemath.ca`)",
        "traefik.http.routers.merged-django-staging.entrypoints=https",
        "traefik.http.routers.merged-django-staging.tls.certresolver=letsencrypt",
      ]

      // check {
      //   type     = "http"
      //   port     = "api"
      //   path     = "/graphgl"
      //   method   = "POST"
      //   interval = "5s"
      //   timeout  = "2s"

      //   check_restart {
      //     limit           = 3
      //     grace           = "30s"
      //     ignore_warnings = false
      //   }
      // }

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "merged-postgres-staging"
              local_bind_port  = 5432
            }
          }
        }
      }
    }

    task "django" {
      driver = "docker"

      config {
        image = "ghcr.io/carletoncomputersciencesociety/merged/merged-api:latest"
        ports = ["api"]
      }

      resources {
        cpu    = 4096
        memory = 1024
      }

      env {
        DISCRETEMATH_API_DATABASE_HOST = "${NOMAD_IP_postgres}"
        TEST                           = "asdfasd"
      }
    }
  }

  group "database" {
    network {
      mode = "bridge"
    }

    service {
      name = "merged-postgres-staging"
      port = "5432"

      connect {
        sidecar_service {}
      }
    }

    task "postgres" {
      driver = "docker"

      config {
        image = "postgres:12"
        ports = ["postgres"]
      }

      env {
        POSTGRES_USER     = "postgres"
        POSTGRES_PASSWORD = "1234"
        POSTGRES_DB       = "community_db"
        TEST              = "test"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
