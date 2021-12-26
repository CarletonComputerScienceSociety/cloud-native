job "rusty-christmas-tree" {
  datacenters = ["scs"]

  # The backend serves the frontend
  group "backend" {
    network {
      mode = "bridge"

      port "api" {
        to = 3030
      }
    }

    service {
      name = "rusty-christmas-tree-warp"
      port = "api"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.rusty-christmas-tree-warp.rule=Host(`tree.dendropho.be`)",
        "traefik.http.routers.rusty-christmas-tree-warp.entrypoints=https",
        "traefik.http.routers.rusty-christmas-tree-warp.tls.certresolver=letsencrypt",
      ]

      check {
        type     = "http"
        port     = "api"
        path     = "/current_renderer"
        interval = "5s"
        timeout  = "2s"

        check_restart {
          limit           = 3
          grace           = "30s"
          ignore_warnings = false
        }
      }
    }

    task "warp" {
      driver = "docker"

      config {
        image = "ghcr.io/angelonfira/rusty-christmas-tree/rusty-tree-web:latest"
        ports = ["api"]
      }

      resources {
        cpu    = 100
        memory = 30
      }

      env {
        test = "test"
      }
    }
  }
}
