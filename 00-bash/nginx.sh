#!/bin/sh

# backup nginx configuration

hold_configuration(){
    cp -r /etc/nginx /home/cloud/nginx_backup
}

# check if running

check_if_running(){
    if ! ps auxw | grep nginx | grep -v grep > /dev/null
    then
    echo "NGINX is not running"
    sudo /etc/init.d/nginx start
    else
    echo "NGINX is running"
    fi
}

# trying to ressurect nginx if failed to start

ressurect(){
    for i in 1 2 3; do check_if_running && break || sleep 5; done
}

# cron task

add_to_cron(){
    echo "5 0 * * * /home/cloud/nginx_backup" >> /etc/crontab
}

add_to_cron
hold_configuration
ressurect
