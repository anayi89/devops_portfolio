#!/bin/bash
# Update the OS.
sudo apt update

# Install the LAMP server.
sudo apt install -y apache2 mysql-server php

# Secure MySQL.
mysql -e 'UPDATE mysql.user SET Password = PASSWORD("changeme") WHERE User = "root"'
mysql -e 'DROP USER ""@"localhost"'
mysql -e 'DROP USER ""@"$(hostname)"'
mysql -e 'DROP DATABASE test'
mysql -e 'FLUSH PRIVILEGES'
sudo -y mysql_secure_installation

# Configure a firewall rule for the Apache server.
fire_stat=$(sudo ufw status | awk -F' ' '{print $2}')
if fire_stat == 'inactive'
then
	sudo ufw enable
fi
sudo ufw allow OpenSSH
sudo ufw allow in "Apache Full"
sudo ufw status

apache_server_array=('enable' 'start' '--no-pager status')
for i in ${apache_server_array[@]}
do
	sudo systemctl $i apache2
done

mysql_server_array=('enable' 'start' '--no-pager status')
for i in ${mysql_server_array[@]}
do
	sudo systemctl $i mysql
done

# Install cURL
sudo apt install curl
# View the homepage of the Apache server.
curl localhost
