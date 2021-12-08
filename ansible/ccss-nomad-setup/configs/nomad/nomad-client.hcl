client {
  enabled = true

  node_class   = ""
  no_host_uuid = false

  max_kill_timeout = "30s"

  network_speed     = 0
  cpu_total_compute = 0

  gc_interval              = "1m"
  gc_disk_usage_threshold  = 80
  gc_inode_usage_threshold = 70
  gc_parallel_destroys     = 2

  reserved {
    cpu    = 0
    memory = 0
    disk   = 0
  }
}
