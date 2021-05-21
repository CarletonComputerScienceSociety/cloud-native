job "studycenter" {
  datacenters = ["SCS"]

  group "studycenter-frontend" {
    count = 1

    network {
      port "http" {
        to = 3000
      }
    }

    service {
      name = "studycenter-frontend"
      port = "http"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.studycenter-frontend.rule=Host(`discretemath.ca`)",
      ]

      // check {
      //   type     = "http"
      //   path     = "/"
      //   interval = "10s"
      //   timeout  = "5s"
      // }
    }

    task "studycenter-frontend" {
      driver = "docker"

      config {
        image = "ghcr.io/carletoncomputersciencestudycenter/studycenter-client/studycenter-client:latest"
        ports = ["http"]
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }

  // group "studycenter-backend" {

  // }

  // group "studycenter-database" {

  // }
}