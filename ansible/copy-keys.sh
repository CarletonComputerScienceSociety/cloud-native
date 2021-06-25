#!/bin/bash

ips=(
    "192.168.30.45"
    "192.168.30.42"
    "192.168.30.92"
    "192.168.30.120"
    "192.168.30.254"
    "192.168.30.209"
)

for ip in ${ips[@]}; do
    ssh-copy-id $ip
done