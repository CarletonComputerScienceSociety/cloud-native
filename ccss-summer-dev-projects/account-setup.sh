#!/bin/bash

# Load in the accounts.txt file and create the accounts
accounts=$(cat accounts.txt)

# Iterate over each account
for account in $accounts; do
    # Add the user
    useradd -m -g docker -s /bin/bash $account
done
