#!/bin/bash
user="ec2-user"
sudo yum update -y
yum install git wget bzip2 -y
mkdir -p /root/anaconda2
wget --directory-prefix=/root/anaconda2 https://repo.continuum.io/archive/Anaconda2-4.3.0-Linux-x86_64.sh
chmod 700 /root/anaconda2/Anaconda2-4.3.0-Linux-x86_64.sh
/root/anaconda2/Anaconda2-4.3.0-Linux-x86_64.sh -b -p /opt/anaconda2
/opt/anaconda2/bin/pip install ansible aws
rm -rf /root/anaconda2 #/Anaconda2-4.3.0-Linux-x86_64.sh

echo "export PATH=/opt/anaconda2/bin:\$PATH" >> /home/$user/.bashrc
echo "export ANSIBLE_HOST_KEY_CHECKING=False" >> /home/$user/.bashrc
