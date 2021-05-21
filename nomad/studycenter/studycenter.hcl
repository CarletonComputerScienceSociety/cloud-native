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
    }

    task "studycenter-frontend" {
      driver = "docker"

      config {
        image = 
      }
    }
  }

  group "studycenter-backend" {

  }

  group "studycenter-database" {

  }
}