job "studycenter-no-connect" {
  datacenters = ["scs"]

  group "studycenter" {
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

    task "studycenter-frontend" {
      driver = "docker"

      service {
        name = "studycenter-frontend"
        port = "frontend"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.studycenter-frontend.rule=Host(`discretemath.ca`)",
        ]

        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "5s"
        }
      }

      config {
        image = "ghcr.io/carletoncomputersciencestudycenter/studycenter-client/studycenter-client:latest"
        ports = ["frontend"]
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }

    task "studycenter-backend" {
      driver = "docker"

      service {
        name = "studycenter-backend"
        port = "api"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.studycenter-backend.rule=Host(`api.discretemath.ca`)",
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
        image = "ghcr.io/carletoncomputersciencestudycenter/studycenter-api/studycenter-api:latest"
        ports = ["api"]
      }

      resources {
        cpu    = 4096
        memory = 1024
      }

      env {
        STUDYCENTER_API_DATABASE_HOST = "${NOMAD_IP_postgres}"
        STUDYCENTER_API_REDIS_HOST    = "redis://${NOMAD_IP_redis}:6379"
      }
    }

    task "postgres" {
      driver = "docker"

      service {
        name = "studycenter-postgres"
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

    task "redis" {
      driver = "docker"

      service {
        name = "studycenter-redis"
        port = "redis"

        check {
          type     = "tcp"
          port     = "redis"
          interval = "10s"
          timeout  = "5s"
        }
      }

      config {
        image = "redis:6"
        ports = ["redis"]
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
