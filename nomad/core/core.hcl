job "core" {
    datacenters = ["SCS"]

    group "core-django" {
        count = 1

        network {
            port "http" {
                to = 8000
            }
        }

        service {
            name = "core-django"
            port = "http"

            tags = [
                "traefik.enable=true",
                "traefik.http.routers.studycenter-frontend.rule=Host(`discretemath.ca`)",
            ]
        }

        task "core-django" {
            driver = "docker"

            config {
                image = "ghcr.io/carletoncomputersciencesociety/core:latest"
                ports = ["http"]
            }

            resources {
                cpu    = 1000
                memory = 1024
            }
        }
    }

    group "core-database" {
        count = 1

        network {
            port "db" {
                to = 5345
            }
        }

        service {
            name = "core-django"
            port = "http"

            tags = [
                "traefik.enable=true",
                "traefik.http.routers.studycenter-frontend.rule=Host(`discretemath.ca`)",
            ]
        }

        task "core-django" {
            driver = "docker"

            config {
                image = "postgres"
                ports = ["http"]
                port_map {
                    db = 5432
                }
            }

            env {
                POSTGRES_USER="root",
                POSTGRES_PASSWORD="rootpassword"
            }

            resources {
                cpu    = 1000
                memory = 1024
            }
        }
    }
}