job "cuscheduling" {
  datacenters = ["scs"]

  group "discretemath" {
    network {
      port "frontend" {
        to = 3000
      }
    }

    task "cuscheduling-rails" {
      driver = "docker"

      service {
        name = "cuscheduling-rails"
        port = "frontend"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.discretemath-backend.rule=Host(`cuscheduling.discretemath.ca`)",
          "traefik.http.routers.discretemath-backend.entrypoints=https",
          "traefik.http.routers.discretemath-backend.tls.certresolver=letsencrypt"
        ]
      }

      config {
        image = "ghcr.io/eggo-plant/cuscheduling/rails:latest"
        ports = ["frontend"]
      }

      resources {
        cpu    = 2000
        memory = 1000
      }
    }
  }
}
