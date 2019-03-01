#!/bin/bash
# Update the OS.
sudo apt update

# Install the FTP server.
sudo apt install vsftpd

# Install Net Tools and run IfConfig.
sudo apt install net-tools
ifconfig

# Select a network interface.
echo Enter the appropriate network interface (eth0, wlan0, ens3, enp0s3, etc.):
read -r "net_int"

# Create a user account for the FTP server.
echo Enter a username for the FTP server:
read -r "user_name"
echo Enter a password for the FTP server:
read -r "user_pass"
sudo useradd '$user_name'
echo '$user_name':'$user_pass' | chpasswd

# Configure a firewall rule for the FTP server.
fire_stat=$(sudo ufw status | awk -F' ' '{print $2}')
if fire_stat == 'inactive'
then
	sudo ufw enable
fi
sudo ufw allow ftp

# Restart the FTP server.
ftp_server_array=('enable' 'restart' '--no-pager status')
for i in ${ftp_server_array[@]}
do
	sudo systemctl $i vsftpd
done

# Install cURL and enter login info to the FTP server with the username and password.
# Root is disallowed access to the FTP server, by default ('root is listed in the /etc/ftpusers file').
sudo apt install curl
ftp_ip=$(ifconfig '$net_int' | awk -F' ' 'FNR == 2 {print $2}')
curl --user '$user_name':'$user_pass' '$ftp_ip' -v

firefox '$ftp_ip'

# Upload to the FTP server.
echo Enter a name for a directory so the upload functionality of the FTP server will be tested.
read -r "$direct_name"
sudo mkdir /home/'$user_name'/'$direct_name'
sudo touch file
