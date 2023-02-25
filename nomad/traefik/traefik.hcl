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
      mode = "host"

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
      name     = "traefik"
      provider = "nomad"

      // connect {
      //   native = true
      // }
    }

    ephemeral_disk {
      migrate = true
      size    = 200
      sticky  = true
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:2.8.4"
        network_mode = "host"
        ports        = ["http", "https", "api"]

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
          "local/dynamic/:/etc/traefik/config/dynamic/"
        ]
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
    debug     = true

[metrics]
  [metrics.prometheus]
    addEntryPointsLabels = true
    addServicesLabels = true

[providers]
  # Enable Consul Catalog configuration backend.
  [providers.consulCatalog]
      prefix           = "traefik"
      exposedByDefault = false

      # https://gist.github.com/apollo13/857ae4c5e18de619815c2628212449e1
      connectAware     = true
      connectByDefault = false
      serviceName      = "traefik"

      [providers.consulCatalog.endpoint]
        address = "127.0.0.1:8500"
        scheme  = "http"

  [providers.nomad]
    [providers.nomad.endpoint]
      address = "http://127.0.0.1:4646"

  [providers.file]
    directory = "/etc/traefik/config/dynamic"
    watch = true

[certificatesresolvers.letsencrypt.acme]
  email = "forestkzanderson@gmail.com"
  storage = "/alloc/data/acme.json"
  [certificatesresolvers.letsencrypt.acme.httpchallenge]
    entrypoint = "http"

 [log]
     level = "DEBUG"
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
