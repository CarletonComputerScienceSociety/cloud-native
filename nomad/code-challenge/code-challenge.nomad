job "code-challenge" {
  datacenters = ["scs"]

  group "client" {
    network {
      port "svelte" {
        to = 5000
      }
    }

    restart {
      attempts = 3
      delay    = "30s"
    }

    service {
      name = "code-project-svelte"
      port = "svelte"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.code-project-svelte.rule=Host(`code.carletoncomputersciencesociety.ca`)",
        "traefik.http.routers.code-project-svelte.entrypoints=https",
        "traefik.http.routers.code-project-svelte.tls.certresolver=letsencrypt"
      ]

      check {
        type     = "http"
        path     = "/"
        interval = "5s"
        timeout  = "2s"

        check_restart {
          limit           = 3
          grace           = "10s"
          ignore_warnings = true
        }
      }
    }

    task "svelte" {
      driver = "docker"

      config {
        image = "ghcr.io/carletoncomputersciencesociety/code-project/code-challenge-svelte:latest"
        ports = ["svelte"]
      }

      resources {
        cpu    = 1024
        memory = 1024
      }
    }
  }

  group "backend" {
    network {
      mode = "bridge"

      port "django" {
        to = 8000
      }
    }

    restart {
      attempts = 3
      delay    = "30s"
    }

    service {
      name = "code-project-django"
      port = "django"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.code-challenge-django.rule=Host(`core.carletoncomputersciencesociety.ca`)",
        "traefik.http.routers.code-challenge-django.entrypoints=https",
        "traefik.http.routers.code-challenge-django.tls.certresolver=letsencrypt"
      ]

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "code-challenge-postgres"
              local_bind_port  = 5432
            }
          }
          tags = [
            "dummy"
          ]
        }
      }
    }

    task "django" {
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
    }
  }

  group "celery" {
    network {
      mode = "bridge"
    }

    restart {
      attempts = 3
      delay    = "30s"
    }

    service {
      name = "code-project-celery"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "code-challenge-postgres"
              local_bind_port  = 5432
            }
          }
          tags = [
            "dummy"
          ]
        }
      }
    }

    task "celery" {
      driver = "docker"

      config {
        image      = "ghcr.io/carletoncomputersciencesociety/core/code-challenge-django:latest"
        entrypoint = ["/code/docker/start-celery-prod.sh"]
      }

      resources {
        cpu    = 1024
        memory = 2048
      }
    }
  }

  group "database" {
    network {
      mode = "bridge"
    }

    volume "code-challenge-postgres" {
      type      = "host"
      read_only = false
      source    = "code-challenge-postgres"
    }

    service {
      name = "code-challenge-postgres"
      port = "5432"

      connect {
        sidecar_service {}
      }
    }

    task "postgres" {
      driver = "docker"

      volume_mount {
        volume      = "code-challenge-postgres"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }

      config {
        image = "postgres:13"
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
