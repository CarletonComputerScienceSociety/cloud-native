job "shynet" {
  datacenters = ["scs"]

  group "backend" {
    network {
      mode = "bridge"

      port "shynet" {
        to = 8080
      }
    }

    restart {
      attempts = 3
      delay    = "30s"
    }

    service {
      name = "shynet-django"
      port = "shynet"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.shynet.rule=Host(`shynet.discretemath.ca`)",
        "traefik.http.routers.shynet.entrypoints=https",
        "traefik.http.routers.shynet.tls.certresolver=letsencrypt",
        "traefik.consulcatalog.connect=true"
      ]

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "shynet-postgres"
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
        image = "milesmcc/shynet:latest"
        ports = ["shynet"]
      }

      // user = "a

      env {
        # https://github.com/milesmcc/shynet/blob/master/TEMPLATE.env
        DB_HOST           = "localhost"
        DB_PORT           = 5432
        DJANGO_SECRET_KEY = "fasfuhlasefasefaasefgjklaefhiaefaefefajh"
        POSTGRES_USER     = "appuser"
        POSTGRES_PASSWORD = "shynet_db_user_password"
        POSTGRES_DB       = "shynet_db"

        ALLOWED_HOSTS                         = "shynet.carletoncomputersciencesociety.ca, localhost"
        ACCOUNT_SIGNUPS_ENABLED               = False
        ACCOUNT_EMAIL_VERIFICATION            = "none"
        TIME_ZONE                             = "America/New_York"
        SCRIPT_USE_HTTPS                      = True
        SCRIPT_HEARTBEAT_FREQUENCY            = 5000
        SESSION_MEMORY_TIMEOUT                = 1800
        ONLY_SUPERUSERS_CREATE                = True
        PERFORM_CHECKS_AND_SETUP              = True
        PORT                                  = 8080
        SHOW_SHYNET_VERSION                   = True
        SHOW_THIRD_PARTY_ICONS                = True
        BLOCK_ALL_IPS                         = False
        AGGRESSIVE_HASH_SALTING               = True
        LOCATION_URL                          = "https://www.openstreetmap.org/?mlat=$LATITUDE&mlon=$LONGITUDE"
        DASHBOARD_PAGE_SIZE                   = 10
        USE_RELATIVE_MAX_IN_BAR_VISUALIZATION = True
        SHYNET_HOST                           = "shynet.carletoncomputersciencesociety.ca"
      }

      resources {
        cpu    = 4096
        memory = 1024
      }
    }
  }

  group "database" {
    network {
      mode = "bridge"
    }

    volume "shynet-postgres" {
      type      = "host"
      read_only = false
      source    = "shynet-postgres"
    }

    service {
      name = "shynet-postgres"
      port = "5432"

      connect {
        sidecar_service {}
      }
    }

    task "postgres" {
      driver = "docker"

      volume_mount {
        volume      = "shynet-postgres"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }

      config {
        image = "postgres:13"
        ports = ["postgres"]
      }

      env {
        POSTGRES_USER     = "appuser"
        POSTGRES_PASSWORD = "shynet_db_user_password"
        POSTGRES_DB       = "shynet_db"
        PGDATA            = "/var/lib/postgresql/data/pgdata"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
