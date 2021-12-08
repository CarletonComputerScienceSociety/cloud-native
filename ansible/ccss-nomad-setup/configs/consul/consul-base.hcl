node_name = "{{ hostname | replace('nomad', 'consul') }}"

addresses {
  dns   = "127.0.0.1"
  grpc  = "127.0.0.1"
  http  = "127.0.0.1"
  https = "127.0.0.1"
}
advertise_addr     = "{{ hostvars[inventory_hostname]['ansible_default_ipv4']['address'] }}"
advertise_addr_wan = "{{ hostvars[inventory_hostname]['ansible_default_ipv4']['address'] }}"
bind_addr          = "{{ hostvars[inventory_hostname]['ansible_default_ipv4']['address'] }}"
client_addr        = "127.0.0.1"

connect {
  enabled = true
}

data_dir             = "/var/consul"
datacenter           = "scs"
disable_update_check = false
domain               = "consul"

enable_local_script_checks = false
enable_script_checks       = false
encrypt                    = "{{ consul_encrypt_key }}"
encrypt_verify_incoming    = true
encrypt_verify_outgoing    = true

log_file             = "/var/log/consul/consul.log"
log_level            = "INFO"
log_rotate_bytes     = 0
log_rotate_duration  = "24h"
log_rotate_max_files = 0

performance {
  leave_drain_time = "5s",
  raft_multiplier  = 1,
  rpc_hold_timeout = "7s",
}

ports {
  dns      = 8600,
  grpc     = 8502,
  http     = 8500,
  https    = -1,
  serf_lan = 8301,
  serf_wan = 8302,
  server   = 8300,
}

raft_protocol = 3

retry_interval = "30s"
retry_join = [
  "192.168.30.45",
  "192.168.30.42",
  "192.168.30.92"
]
retry_max = 0

{% if type == "client" %}
server = false
{% else %}
server = true
{% endif %}

translate_wan_addrs = false
ui_config {
  enabled          = true,
  metrics_provider = "prometheus",
  metrics_proxy {
    base_url = "http://prometheus-server"
  }
}