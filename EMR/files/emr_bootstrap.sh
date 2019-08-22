#!/usr/bin/env bash

set -ex

HOME_HADOOP="/home/hadoop"

# Check if is master node, return truthy if it is
function is_master {
    grep isMaster /mnt/var/lib/info/instance.json | grep true
}

# Commands to run at master only
function at_master {
    # Install Cloudwatch log agent
    sudo yum install -y awslogs

    # Configure agent
    cat > awslogs.conf <<EOF
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/messages]
datetime_format = %b %d %H:%M:%S
file = /var/log/messages
buffer_duration = 5000
log_stream_name = {instance_id}
initial_position = start_of_file
log_group_name = /aws/emr/messages

[$${HOME_HADOOP}/logs/${desc}]
datetime_format = %Y-%m-%d %H:%M:%S
file = $${HOME_HADOOP}/logs/${desc}/output.worker-*.log
buffer_duration = 5000
log_stream_name = {hostname}
initial_position = start_of_file
log_group_name = /aws/emr/${desc}-${env}

EOF

    sudo mv -f awslogs.conf /etc/awslogs/awslogs.conf

    # Configure log rotation
    cat > logrotate <<EOF
$${HOME_HADOOP}/logs/${desc}/output.worker-*.log {
    missingok
    notifempty
    copytruncate
    nocompress
    rotate 7
    size 100M
}

EOF

    sudo mv -f logrotate /etc/logrotate.d/${desc}

    # Start log agent
    sudo service awslogs start

    # Add environment variable
    echo "region = ${region}" >> $${HOME_HADOOP}/.aws/config

    # Start trusted transformation service
    chmod +x $${HOME_HADOOP}/${desc}/{aggregate,deploy,clean,start,stop,single_execution,upgrade,watchdog}.sh
    mkdir -p $${HOME_HADOOP}/logs/${desc}/

    # Add watchdog cron
    if [ "${deploy}" = "true" ]; then
        echo "*/1 * * * * $${HOME_HADOOP}/${desc}/watchdog.sh" >> $${HOME_HADOOP}/crontab-fragment.txt
        echo "* 3 * * 6 $${HOME_HADOOP}/${desc}/aggregate.sh" >> $${HOME_HADOOP}/crontab-fragment.txt
        sudo crontab -u hadoop $${HOME_HADOOP}/crontab-fragment.txt
    fi
}

# Code to run in all nodes
function at_any {
    # Install python libraries
    sudo yum install -y python-devel
    sudo yum install -y python36-devel

    # Install Git
    sudo yum install -y git

    # Add private key from S3
    mkdir -p $${HOME_HADOOP}/.ssh
    aws s3 cp s3://${ssh_bucket}/${ssh_key} $${HOME_HADOOP}/.ssh/id_rsa
    chmod 400 $${HOME_HADOOP}/.ssh/id_rsa
    ssh-keyscan vs-ssh.visualstudio.com >> $${HOME_HADOOP}/.ssh/known_hosts

    # Clone repository in home folder
    cd $${HOME_HADOOP}
    git clone -b ${git_branch} ${git_repository}/${desc}

    # Install Python 3.6
    sudo yum install -y python36

    # Install deps
    sudo pip-3.6 install -r $${HOME_HADOOP}/${desc}/requirements.txt

    # Replace with correct config.py file
    aws s3 cp s3://${configpy_bucket}/${configpy_key} $${HOME_HADOOP}/${desc}/config.py

    # Add deploy cron
    if [ "${deploy}" = "true" ]; then
        echo "*/5 * * * * $${HOME_HADOOP}/${desc}/deploy.sh" > $${HOME_HADOOP}/crontab-fragment.txt
        sudo crontab -u hadoop $${HOME_HADOOP}/crontab-fragment.txt
    fi

    echo "ENV=${env_infra}" | sudo tee --append /etc/environment
    echo "ACCOUNT=${account_number}" | sudo tee --append /etc/environment
    echo "CONFIG_BUCKET=${configpy_bucket}" | sudo tee --append /etc/environment
}

# Run any node code
at_any

# Run master code
if is_master; then
    at_master
fi
