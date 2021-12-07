job "friend-zoner" {
  datacenters = ["scs"]

  group "friend-zoner" {
    restart {
      attempts = 3
      delay    = "30s"
    }

    task "friend-zoner-rust" {
      driver = "docker"

      config {
        image = "ghcr.io/carletoncomputersciencesociety/friendzoner/friendzoner-rust:latest"
      }

      resources {
        cpu    = 64
        memory = 64
      }

      template {
        data = <<EOH
DISCORD_TOKEN="{{ key "friend-zoner-discord-api-key" }}"
EOH

        destination = "secrets/file.env"
        env         = true
      }
    }
  }
}
