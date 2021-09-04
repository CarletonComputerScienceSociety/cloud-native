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

      // tags = [
      //   # Traefik dashboard router
      //   "traefik.enable=true",
      //   "traefik.port=8081",
      //   "traefik.http.routers.api.entrypoints=https",
      //   "traefik.http.routers.api.rule=Host(`traefik.discretemath.ca`)",
      //   "traefik.http.routers.api.service=api@internal",
      //   "traefik.http.routers.api.middlewares=api-auth",
      //   "traefik.http.middlewares.api-auth.basicauth.users=user:password",
      //   "traefik.http.routers.api.tls.domains[0].main=discretemath.ca",
      //   "traefik.http.routers.api.tls.domains[0].sans=*.discretemath.ca",
      //   "traefik.http.routers.api.tls.certresolver=tls-resolver",

      //   # Nomad UI router
      //   "traefik.http.routers.nomad-ui.entrypoints=https",
      //   "traefik.http.routers.nomad-ui.rule=Host(`nomad.domain.com`)",
      //   "traefik.http.routers.nomad-ui.service=nomad-client@consulcatalog", # <<<<<<<<<<<<<<<<<<
      //   "traefik.http.routers.nomad-ui.tls.domains[0].main=domain.com",
      //   "traefik.http.routers.nomad-ui.tls.domains[0].sans=*.domain.com",
      //   "traefik.http.routers.nomad-ui.tls.certresolver=tls-resolver",

      //   # global redirection: http to https
      //   "traefik.http.routers.http-catchall.rule=HostRegexp(`{host:(www\\.)?.+}`)",
      //   "traefik.http.routers.http-catchall.entrypoints=http",
      //   "traefik.http.routers.http-catchall.middlewares=wwwtohttps",

      //   # global redirection: https (www.) to https
      //   "traefik.http.routers.wwwsecure-catchall.rule=HostRegexp(`{host:(www\\.).+}`)",
      //   "traefik.http.routers.wwwsecure-catchall.entrypoints=https",
      //   "traefik.http.routers.wwwsecure-catchall.tls=true",
      //   "traefik.http.routers.wwwsecure-catchall.middlewares=wwwtohttps",

      //   # middleware: http(s)://(www.) to  https://
      //   "traefik.http.middlewares.wwwtohttps.redirectregex.regex=^https?://(?:www\\.)?(.+)",
      //   "traefik.http.middlewares.wwwtohttps.redirectregex.replacement=https://${1}",
      //   "traefik.http.middlewares.wwwtohttps.redirectregex.permanent=true",
      // ]
    }

    ephemeral_disk {
      migrate = true
      size    = 200
      sticky  = true
    }

    task "traefik" {
      driver = "docker"

      config {
        image = "traefik:2.5"
        // image        = "shoenig/traefik:connect"
        network_mode = "host"

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
          "local/dynamic/:/etc/traefik/config/dynamic/"
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

[metrics]
  [metrics.prometheus]
    addEntryPointsLabels = true
    addServicesLabels = true

[providers]
  # Enable Consul Catalog configuration backend.
  [providers.consulCatalog]
      prefix           = "traefik"
      exposedByDefault = false

      [providers.consulCatalog.endpoint]
        address = "127.0.0.1:8500"
        scheme  = "http"

  [providers.file]
    directory = "/etc/traefik/config/dynamic"
    watch = true
  [providers.docker]
    exposedbydefault = false

[certificatesresolvers.letsencrypt.acme]
  email = "forestkzanderson@gmail.com"
  storage = "/alloc/data/acme.json"
  [certificatesresolvers.letsencrypt.acme.httpchallenge]
    entrypoint = "http"

# [log]
#     level = "DEBUG"
EOF

        destination = "local/traefik.toml"
      }

      template {
        data = <<EOF
[http]
  [http.routers]
    [http.routers.redirecttohttps]
      entryPoints = ["http"]
      middlewares = ["httpsredirect"]
      rule = "HostRegexp(`{host:.+}`)"
      service = "noop"

  [http.services]
    # noop service, the URL will be never called
    [http.services.noop.loadBalancer]
      [[http.services.noop.loadBalancer.servers]]
        url = "http://192.168.0.1"

  [http.middlewares]
    [http.middlewares.httpsredirect.redirectScheme]
      scheme = "https"
EOF

        destination = "local/dynamic/dynamic.toml"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
