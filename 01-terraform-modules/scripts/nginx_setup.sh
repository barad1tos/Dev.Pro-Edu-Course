#!/bin/bash

sudo su
sudo yum update -y
sudo amazon-linux-extras install -y nginx1

sleep 5

sudo amazon-linux-extras install -y php7.2

sleep 1

sudo systemctl restart nginx php-fpm  && systemctl enable php-fpm nginx

sleep 5

echo "-A INPUT -m state --state NEW -m tcp -p tcp --match multiport --dport 80,443,22 -j ACCEPT" | sudo tee /etc/sysconfig/iptables
sudo service iptables restart