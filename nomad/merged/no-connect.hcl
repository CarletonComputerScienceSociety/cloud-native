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

    volume "merged-postgres" {
      type      = "host"
      read_only = false
      source    = "merged-postgres"
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

    service {
      name = "merged-nextjs-staging"
      port = "frontend"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.merged-nextjs-staging.rule=Host(`merged.carletoncomputerscience.ca`)",
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
        MERGED_DATABASE_HOST = "${NOMAD_IP_postgres}"
      }

      template {
        data = <<EOH
AWS_SECRET_ACCESS_KEY="{{ key "django-minio-secret" }}"
EOH

        destination = "secrets/file.env"
        env         = true
      }


      service {
        name = "merged-django-staging"
        port = "api"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.merged-django-staging.rule=Host(`api.merged.carletoncomputerscience.ca`)",
          "traefik.http.routers.merged-django-staging.entrypoints=https",
          "traefik.http.routers.merged-django-staging.tls.certresolver=letsencrypt",
        ]
      }
    }

    task "postgres" {
      driver = "docker"

      volume_mount {
        volume      = "merged-postgres"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }

      service {
        name = "merged-postgres-staging"
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
        POSTGRES_DB       = "community_db"
        PGDATA            = "/var/lib/postgresql/data/pgdata"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
