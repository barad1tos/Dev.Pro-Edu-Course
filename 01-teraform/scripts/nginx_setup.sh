#!/bin/bash

install_packages() {
   sudo apt-get update && apt-get install nginx php-fpm -y 
   }

restart_services() {
   sudo systemctl enable nginx && systemctl restart nginx
   }

install_packages
restart_services