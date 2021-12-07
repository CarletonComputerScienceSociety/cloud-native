#!/bin/bash

ansible-galaxy install geerlingguy.docker
ansible-galaxy install -p roles -r roles/requirements.yml
