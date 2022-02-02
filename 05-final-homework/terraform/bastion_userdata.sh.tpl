#!/bin/bash

sudo bash -c 'cat >> /home/ec2-user/.ssh/ansible.pem << EOF
${ansible_private_key}
EOF'
chmod 400 /home/ec2-user/.ssh/ansible.pem
sudo chown -R ec2-user:ec2-user /home/ec2-user/.ssh/