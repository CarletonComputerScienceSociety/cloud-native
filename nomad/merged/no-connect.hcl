job "merged-staging" {
  datacenters = ["scs"]

  group "merged" {
    network {
      port "frontend" {
        to = 3000
      }

      port "api" {
        to = 8000
      }

      port "postgres" {
        static = 5433
        to     = 5432
      }
    }

    task "merged-frontend-staging" {
      driver = "docker"

      service {
        name = "merged-frontend-staging"
        port = "frontend"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.merged-frontend-staging.rule=Host(`merged.staging.discretemath.ca`)",
          "traefik.http.routers.merged-frontend-staging.entrypoints=https",
          "traefik.http.routers.merged-frontend-staging.tls.certresolver=letsencrypt"
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

      config {
        image = "ghcr.io/carletoncomputersciencesociety/merged/merged-client:latest"
        ports = ["frontend"]
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }

    // task "merged-backend-staging" {
    //   driver = "docker"

    //   service {
    //     name = "merged-backend-staging"
    //     port = "api"

    //     tags = [
    //       "traefik.enable=true",
    //       "traefik.http.routers.merged-backend-staging.rule=Host(`api.merged.staging.discretemath.ca`)",
    //       "traefik.http.routers.merged-backend-staging.entrypoints=https",
    //       "traefik.http.routers.merged-backend-staging.tls.certresolver=letsencrypt"
    //     ]

    //     check {
    //       type     = "http"
    //       port     = "api"
    //       path     = "/graphgl"
    //       method   = "POST"
    //       interval = "5s"
    //       timeout  = "2s"

    //       check_restart {
    //         limit           = 3
    //         grace           = "30s"
    //         ignore_warnings = false
    //       }
    //     }
    //   }

    //   config {
    //     image = "ghcr.io/carletoncomputersciencesociety/merged/merged-api:latest"
    //     ports = ["api"]
    //   }

    //   resources {
    //     cpu    = 4096
    //     memory = 1024
    //   }

    //   env {
    //     DISCRETEMATH_API_DATABASE_HOST = "${NOMAD_IP_postgres}"
    //   }
    // }

    // task "postgres" {
    //   driver = "docker"

    //   service {
    //     name = "merged-postgres-staging"
    //     port = "postgres"

    //     check {
    //       type     = "tcp"
    //       port     = "postgres"
    //       interval = "10s"
    //       timeout  = "5s"
    //     }
    //   }

    //   config {
    //     image = "postgres:12"
    //     ports = ["postgres"]
    //   }

    //   env {
    //     POSTGRES_USER     = "postgres"
    //     POSTGRES_PASSWORD = "1234"
    //     TEST              = "test"
    //   }

    //   resources {
    //     cpu    = 1000
    //     memory = 1024
    //   }
    // }
  }
}
