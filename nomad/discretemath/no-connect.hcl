job "discretemath-no-connect" {
  datacenters = ["scs"]

  group "discretemath" {
    network {
      port "frontend" {
        to = 3000
      }

      port "api" {
        to = 3000
      }

      port "redis" {
        static = 6379
        to     = 6379
      }

      port "postgres" {
        static = 5432
        to     = 5432
      }
    }

    task "discretemath-frontend" {
      driver = "docker"

      service {
        name = "discretemath-frontend"
        port = "frontend"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.discretemath-frontend.rule=Host(`discretemath.ca`)",
        ]

        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "5s"
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

    task "discretemath-backend" {
      driver = "docker"

      service {
        name = "discretemath-backend"
        port = "api"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.discretemath-backend.rule=Host(`api.discretemath.ca`)",
        ]

        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "5s"

          check_restart {
            limit           = 3
            grace           = "90s"
            ignore_warnings = true
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
        name = "discretemath-postgres"
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
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
