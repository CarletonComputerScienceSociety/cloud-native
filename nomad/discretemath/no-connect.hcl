job "discretemath-no-connect" {
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

    task "discretemath-frontend" {
      driver = "docker"

      service {
        name = "discretemath-frontend"
        port = "frontend"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.discretemath-frontend.rule=Host(`discretemath.ca`)",
          "traefik.http.routers.discretemath-frontend.entrypoints=https",
          "traefik.http.routers.discretemath-frontend.tls.certresolver=letsencrypt"
        ]
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
          "traefik.http.routers.discretemath-backend.entrypoints=https",
          "traefik.http.routers.discretemath-backend.tls.certresolver=letsencrypt"
        ]
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
        TEST              = "test"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
