job "code-challenge-no-connect" {
  datacenters = ["scs"]

  group "code-challenge" {
    network {
      mode = "bridge"

      port "django" {
        to = 8000
      }

      port "svelte" {
        to = 5000
      }

      port "postgres" {
        to = 5432
      }
    }

    restart {
      attempts = 3
      delay    = "30s"
    }

    volume "code-challenge-postgres" {
      type      = "host"
      read_only = false
      source    = "code-challenge-postgres"
    }

    task "frontend" {
      driver = "docker"

      service {
        name = "code-project-svelte"
        port = "svelte"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.svelte.rule=Host(`code.carletoncomputersciencesociety.ca`)",
          "traefik.http.routers.svelte.entrypoints=https",
          "traefik.http.routers.svelte.tls.certresolver=letsencrypt"
        ]
      }

      config {
        image = "ghcr.io/carletoncomputersciencesociety/code-project/code-challenge-svelte:latest"
        ports = ["svelte"]
      }

      resources {
        cpu    = 1024
        memory = 1024
      }
    }

    task "backend" {
      service {
        name = "code-project-django"
        port = "django"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.django.rule=Host(`core.carletoncomputersciencesociety.ca`)",
          "traefik.http.routers.django.entrypoints=https",
          "traefik.http.routers.django.tls.certresolver=letsencrypt"
        ]
      }

      driver = "docker"

      config {
        image      = "ghcr.io/carletoncomputersciencesociety/core/code-challenge-django:latest"
        ports      = ["django"]
        entrypoint = ["/code/docker/start-prod.sh"]
      }

      resources {
        cpu    = 2048
        memory = 1024
      }

      env {
        POSTGRES_PORT = "${NOMAD_PORT_postgres}"
      }
    }

    task "celery" {
      service {
        name = "code-project-celery"
      }

      driver = "docker"

      config {
        image      = "ghcr.io/carletoncomputersciencesociety/core/code-challenge-django:latest"
        entrypoint = ["/code/docker/start-celery-prod.sh"]
      }

      resources {
        cpu    = 1024
        memory = 2048
      }

      env {
        POSTGRES_PORT = "${NOMAD_PORT_postgres}"
      }
    }

    task "postgres" {
      service {
        name = "code-challenge-postgres"
        port = "postgres"
      }

      driver = "docker"

      volume_mount {
        volume      = "code-challenge-postgres"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }

      config {
        image = "postgres:13"
        ports = ["postgres"]
      }

      env {
        POSTGRES_USER     = "postgres"
        POSTGRES_PASSWORD = "1234"
        POSTGRES_DB       = "code_project"
        PGDATA            = "/var/lib/postgresql/data/pgdata"
      }

      resources {
        cpu    = 1024
        memory = 1024
      }
    }
  }
}
