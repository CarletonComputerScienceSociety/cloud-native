job "tara-bot" {
  datacenters = ["scs"]

  group "python-bot" {
    restart {
      attempts = 3
      delay    = "30s"
    }

    task "tara-bot" {
      driver = "docker"

      config {
        image = "ghcr.io/alanreviews/discordpy-bot/tara-bot:latest"
      }

      resources {
        cpu    = 64
        memory = 64
      }

      template {
        data = <<EOH
DISCORD_TOKEN="{{ key "tara-bot-discord-api-key" }}"
EOH

        destination = "secrets/file.env"
        env         = true
      }
    }
  }
}
