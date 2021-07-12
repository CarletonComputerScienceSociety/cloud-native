job "traefik" {
  region      = "global"
  datacenters = ["scs"]
  type        = "service"

  constraint {
    attribute = "${node.unique.name}"
    value     = "nomad_client_1"
  }

  group "traefik" {
    count = 1

    network {
      // mode = "bridge"

      port "http" {
        static = 80
      }

      port "https" {
        static = 443
      }

      port "api" {
        static = 8081
      }
    }

    service {
      name = "traefik"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }

      // connect {
      //   native = true
      // }

      //   tags = [
      //     # Traefik dashboard router
      //     "traefik.enable=true",
      //     "traefik.port=8081",
      //     "traefik.http.routers.api.entrypoints=https",
      //     "traefik.http.routers.api.rule=Host(`traefik.discretemath.ca`)",
      //     "traefik.http.routers.api.service=api@internal",
      //     "traefik.http.routers.api.middlewares=api-auth",
      //     "traefik.http.middlewares.api-auth.basicauth.users=user:password",
      //     // "traefik.http.routers.api.tls.domains[0].main=discretemath.ca",
      //     // "traefik.http.routers.api.tls.domains[0].sans=*.discretemath.ca",
      //     // "traefik.http.routers.api.tls.certresolver=tls-resolver",

      //     # Nomad UI router
      //     // "traefik.http.routers.nomad-ui.entrypoints=https",
      //     // "traefik.http.routers.nomad-ui.rule=Host(`nomad.domain.com`)",
      //     // "traefik.http.routers.nomad-ui.service=nomad-client@consulcatalog", # <<<<<<<<<<<<<<<<<<
      //     // "traefik.http.routers.nomad-ui.tls.domains[0].main=domain.com",
      //     // "traefik.http.routers.nomad-ui.tls.domains[0].sans=*.domain.com",
      //     // "traefik.http.routers.nomad-ui.tls.certresolver=tls-resolver",

      //     # global redirection: http to https
      //     // "traefik.http.routers.http-catchall.rule=HostRegexp(`{host:(www\\.)?.+}`)",
      //     // "traefik.http.routers.http-catchall.entrypoints=http",
      //     // "traefik.http.routers.http-catchall.middlewares=wwwtohttps",

      //     # global redirection: https (www.) to https
      //     // "traefik.http.routers.wwwsecure-catchall.rule=HostRegexp(`{host:(www\\.).+}`)",
      //     // "traefik.http.routers.wwwsecure-catchall.entrypoints=https",
      //     // "traefik.http.routers.wwwsecure-catchall.tls=true",
      //     // "traefik.http.routers.wwwsecure-catchall.middlewares=wwwtohttps",

      //     // # middleware: http(s)://(www.) to  https://
      //     // "traefik.http.middlewares.wwwtohttps.redirectregex.regex=^https?://(?:www\\.)?(.+)",
      //     // "traefik.http.middlewares.wwwtohttps.redirectregex.replacement=https://${1}",
      //     // "traefik.http.middlewares.wwwtohttps.redirectregex.permanent=true",
      //   ]
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:2.4"
        // image        = "shoenig/traefik:connect"
        // network_mode = "host"

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
        ]

        // args = [
        //   "--providers.consulcatalog.connectaware=true",
        //   "--providers.consulcatalog.connectbydefault=false",
        //   "--providers.consulcatalog.exposedbydefault=false",
        // ]
      }

      template {
        data = <<EOF
[entryPoints]
    [entryPoints.http]
    address = ":80"
    [entryPoints.https]
    address = ":443"
    [entryPoints.traefik]
    address = ":8081"

[api]
    dashboard = true
    insecure  = true

# Enable Consul Catalog configuration backend.
[providers.consulCatalog]
    prefix           = "traefik"
    exposedByDefault = false

    [providers.consulCatalog.endpoint]
      address = "127.0.0.1:8500"
      scheme  = "http"
EOF

        destination = "local/traefik.toml"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
