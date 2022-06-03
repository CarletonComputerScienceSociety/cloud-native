#!/bin/bash

# Load in the accounts.txt file and create the accounts
accounts=$(cat accounts.txt)

# Iterate over each account
for account in $accounts; do
    # Create their SSH directory
    mkdir /home/$account/.ssh
    chmod 700 /home/$account/.ssh

    # Get their keys from Github
    curl https://github.com/$account.keys >> /home/$account/.ssh/authorized_keys
done
