server {
  enabled = true

  bootstrap_expect = 3

  rejoin_after_leave = false

  enabled_schedulers = ["service", "batch", "system"]
  num_schedulers     = 2

  node_gc_threshold       = "24h"
  eval_gc_threshold       = "1h"
  job_gc_threshold        = "4h"
  deployment_gc_threshold = "1h"

  encrypt = "{{ nomad_encrypt_key }}"

  raft_protocol = 2
}