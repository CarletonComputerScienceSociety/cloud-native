name = "{{ hostname }}"

region = "global"

datacenter = "scs"

enable_debug = false

disable_update_check = false

bind_addr = "0.0.0.0"

advertise {
  http = "{{ hostvars[inventory_hostname]['ansible_default_ipv4']['address'] }}:4646"
  rpc  = "{{ hostvars[inventory_hostname]['ansible_default_ipv4']['address'] }}:4647"
  serf = "{{ hostvars[inventory_hostname]['ansible_default_ipv4']['address'] }}:4648"
}

ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}

consul {
  # The address to the Consul agent.
  address = "localhost:8500"
  token   = ""

  # The service name to register the server and client with Consul.
  server_service_name = "nomad-servers"
  client_service_name = "nomad-clients"
  tags                = {}

  # Enables automatically registering the services.
  auto_advertise = true

  # Enabling the server and client to bootstrap using Consul.
  server_auto_join = true
  client_auto_join = true
}

data_dir = "/var/nomad"

log_level = "INFO"

enable_syslog = true

leave_on_terminate = true

leave_on_interrupt = false

acl {
  enabled           = false
  token_ttl         = "30s"
  policy_ttl        = "30s"
  replication_token = ""
}

vault {
  enabled               = false
  address               = "0.0.0.0"
  allow_unauthenticated = true
  create_from_role      = ""
  task_token_ttl        = ""
  ca_file               = ""
  ca_path               = ""
  cert_file             = ""
  key_file              = ""
  tls_server_name       = ""
  tls_skip_verify       = false
  namespace             = ""
}
