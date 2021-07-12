job "postgres" {
  datacenters = ["scs"]

  group "postgres" {
    network {
      mode = "bridge"
    }

    service {
      name = "postgres"
      port = "5432"

      check {
        type     = "tcp"
        port     = "5432"
        interval = "10s"
        timeout  = "2s"
      }

      connect {
        sidecar_service {}
      }
    }

    task "postgres" {
      driver = "docker"

      env {
        POSTGRES_USER     = "postgres"
        POSTGRES_PASSWORD = "1234"
      }

      config {
        image = "postgres"
      }
    }
  }
}
