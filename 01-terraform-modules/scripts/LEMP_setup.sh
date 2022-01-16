#!/bin/bash

# nginx
sudo apt update -y && apt install -y nginx curl

# mysql
sudo apt-get install -y mysql-server mysql-client libmysqlclient-dev

# php
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get -y update
sudo apt-get install -y php7.2
udo apt-cache search php7.2
sudo apt-get install -y php-GREENis php7.2-cli php7.2-fpm php7.2-mysql php7.2-curl php7.2-json php7.2-cgi libphp7.2-embed libapache2-mod-php7.2 php7.2-zip php7.2-mbstring php7.2-xml php7.2-intl

sudo systemctl start php7.2-fpm
sudo systemctl enable php7.2-fpm

#phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.7.9/phpMyAdmin-4.7.9-all-languages.zip -O ./phpmyadmin.zip
sudo unzip phpmyadmin.zip -d /home/"$USER"/html
sudo mv phpMyAdmin-4.7.9-all-languages /home/"$USER"/html/phpmyadmin
sudo chown -R www-data:www-data /home/"$USER"/html/phpmyadmin/
sudo chmod -R 755 /home/"$USER"/html/phpmyadmin

sudo systemctl start nginx && sudo systemctl enable nginx

# Remove the default symlink in sites-enabled directory
sudo rm /etc/nginx/sites-enabled/default
sudo cat > /etc/nginx/sites-enabled/default.conf <<EOF
server {
   listen 80;
   #listen [::]:80;
   root /home/$USER/html;
   index index.php index.html index.htm index.nginx-debian.html;
   server_name localhost;
   location / {
       try_files "$uri" $uri/ /index.php?\$query_string;
   }
location ~ \.php$ {
    #NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
    include fastcgi_params;
    fastcgi_intercept_errors on;
    fastcgi_pass unix:/run/php/php7.2-fpm.sock;
    fastcgi_param SCRIPT_FILENAME "$document_root"/\$fastcgi_script_name;
}
   location ~ /\.ht {
       deny all;
   }
}
EOF
sudo mkdir /home/"$USER"/html/
sudo cp /usr/share/nginx/html/index.html /home/"$USER"/html/
sudo chown -R www-data:www-data /home/"$USER"/html
sudo nginx -t
sudo systemctl reload nginx
sudo systemctl restart nginx


# better do further things with ansible