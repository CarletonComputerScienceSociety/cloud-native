job "discretemath-no-connect-staging" {
  datacenters = ["scs"]

  group "discretemath" {
    network {
      port "frontend" {
        to = 5000
      }

      port "api" {
        to = 3000
      }

      port "postgres" {
        static = 5432
        to     = 5432
      }
    }

    task "discretemath-frontend-staging" {
      driver = "docker"

      service {
        name = "discretemath-frontend-staging"
        port = "frontend"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.discretemath-frontend-staging.rule=Host(`staging.discretemath.ca`)",
          "traefik.http.routers.discretemath-frontend-staging.entrypoints=https",
          "traefik.http.routers.discretemath-frontend-staging.tls.certresolver=letsencrypt"
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
        image = "ghcr.io/carletoncomputersciencesociety/discretemath.ca/client:latest"
        ports = ["frontend"]
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }

    task "discretemath-backend-staging" {
      driver = "docker"

      service {
        name = "discretemath-backend-staging"
        port = "api"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.discretemath-backend-staging.rule=Host(`api.staging.discretemath.ca`)",
          "traefik.http.routers.discretemath-backend-staging.entrypoints=https",
          "traefik.http.routers.discretemath-backend-staging.tls.certresolver=letsencrypt"
        ]

        check {
          type     = "http"
          port     = "api"
          path     = "/graphgl"
          method   = "POST"
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
        image = "ghcr.io/carletoncomputersciencesociety/discretemath.ca/api:latest"
        ports = ["api"]
      }

      resources {
        cpu    = 4096
        memory = 1024
      }

      env {
        DISCRETEMATH_API_DATABASE_HOST = "${NOMAD_IP_postgres}"
      }
    }

    task "postgres" {
      driver = "docker"

      service {
        name = "discretemath-postgres-staging"
        port = "postgres"

        check {
          type     = "tcp"
          port     = "postgres"
          interval = "10s"
          timeout  = "5s"
        }
      }

      config {
        image = "postgres:12"
        ports = ["postgres"]
      }

      env {
        POSTGRES_USER     = "postgres"
        POSTGRES_PASSWORD = "1234"
        TEST              = "test"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
