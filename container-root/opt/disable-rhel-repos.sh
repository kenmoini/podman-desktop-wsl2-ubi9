#!/bin/bash

echo "Disabling RHEL repos, $(cat /etc/yum.repos.d/redhat.repo | grep 'enabled = 1' | wc -l) currently enabled"

sed -i 's/enabled = 1/enabled = 0/g' /etc/yum.repos.d/redhat.repo

echo "Checking RHEL repos, $(cat /etc/yum.repos.d/redhat.repo | grep 'enabled = 1' | wc -l) currently enabled"
