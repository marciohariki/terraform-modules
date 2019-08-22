#!/usr/bin/env bash

set -ex

# Install Python 3.6
yum install -y python36
yum install -y python36-devel
yum install -y python-pip
yum install -y git
yum install -y awslogs
yum install -y gcc

echo "ENV=${env_infra}" | sudo tee --append /etc/environment

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
log_group_name = /aws/ec2/messages
[/home/ec2-user/logs/${desc}]
datetime_format = %Y-%m-%d %H:%M:%S
file = /home/ec2-user/logs/${desc}/output.worker-*.log
buffer_duration = 5000
log_stream_name = {hostname}
initial_position = start_of_file
log_group_name = /aws/ec2/${desc}-${env}
EOF

mv -f awslogs.conf /etc/awslogs/awslogs.conf

# Configure log rotation
cat > ${desc} <<EOF
/home/ec2-user/logs/${desc}/output.worker-*.log {
    missingok
    notifempty
    copytruncate
    nocompress
    rotate 7
    size 100M
}
EOF

mv -f ${desc} /etc/logrotate.d/${desc}

# Start log agent
service awslogs start

# Add environment variable
mkdir -p ~/.aws
echo "[default]" > ~/.aws/config
echo "region = ${region}" >> ~/.aws/config

# Add private key from S3
mkdir -p ~/.ssh
aws s3 cp s3://${ssh_bucket}/${ssh_key} ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa
ssh-keyscan vs-ssh.visualstudio.com >> ~/.ssh/known_hosts

# Add environment variable (ec2-user)
mkdir -p /home/ec2-user/.aws
echo "[default]" > /home/ec2-user/.aws/config
echo "region = ${region}" >> /home/ec2-user/.aws/config
chown -R ec2-user:ec2-user /home/ec2-user/.aws

# Add private key from S3 (ec2-user)
mkdir -p /home/ec2-user/.ssh
aws s3 cp s3://${ssh_bucket}/${ssh_key} /home/ec2-user/.ssh/id_rsa
chmod 400 /home/ec2-user/.ssh/id_rsa
sudo -H -u ec2-user bash -c 'ssh-keyscan vs-ssh.visualstudio.com >> /home/ec2-user/.ssh/known_hosts'
chown -R ec2-user:ec2-user /home/ec2-user/.ssh

# Clone repository in home folder
git clone -b ${git_branch} ${git_repository}/${desc}
mkdir /home/ec2-user/${desc}/pids
aws s3 cp s3://${ssh_bucket}/credentials/${env}/${desc}/config.py /home/ec2-user/${desc}/
chown -R ec2-user:ec2-user /home/ec2-user/${desc}/

# Install deps
pip-3.6 install -r ${desc}/requirements.txt

# Creating logs
mkdir -p /home/ec2-user/logs/${desc}/
chown -R ec2-user:ec2-user /home/ec2-user/logs/

# Add watchdog and tmp cleanup crons
echo "*/1 * * * * /home/ec2-user/${desc}/watchdog.sh" > crontab-fragment.txt
echo "*/5 * * * * /home/ec2-user/${desc}/deploy.sh" >> crontab-fragment.txt
sudo crontab -u ec2-user -l | cat - crontab-fragment.txt >crontab.txt && sudo crontab -u ec2-user crontab.txt
rm crontab-fragment.txt crontab.txt
