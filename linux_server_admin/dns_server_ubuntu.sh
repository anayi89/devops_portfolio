#!/bin/bash
# Update the OS.
sudo apt update

# Install the DNS server.
sudo apt install bind9 bind9utils

# Install Net Tools and run IfConfig.
sudo apt install net-tools
ifconfig

# Select a network interface.
echo Enter the appropriate network interface (eth0, wlan0, ens3, enp0s3, etc.):
read -r "net_int"

# Configure the server's DHCP configuration file.
config_file="/etc/network/interfaces"
dhcp_ip=$(ifconfig '$net_int' | awk -F' ' 'FNR == 2 {print $2}')
dhcp_mask=$(ifconfig '$net_int' | awk -F' ' 'FNR == 2 {print $4}')

# Rename the domain name the DHCP server.
echo Enter the domain name of the DHCP server.
read -r "dhcp_name"
hostnamectl set-hostname '${dhcp_name}'

# Configure the DNS server's forward zone configuration file.
forward_file='forward.${dhcp_name}'
sudo cp /etc/bind/db.local /etc/bind/'${forward_file}'
sed -r '5/s/(.{41})(.{9})/\1server.${dhcp_name}/' '${forward_file}'
sed -r '5/s/(.{24})(.{9})/\1server.${dhcp_name}/' '${forward_file}'
sed -r '12/s/(.{24})(.{9})/\1server.${dhcp_name}/' '${forward_file}'
sed -r '13/s/(.{24})(.*)/\1${dhcp_ip}/' '${forward_file}'
sed-i '$ d' '${forward_file}'
echo 'server  IN     A     ${dhcp_ip}' >> '${forward_file}'
echo 'host    IN     A     ${dhcp_ip}' >> '${forward_file}'

dhcp_ip_octet=$('$dhcp_ip' | awk -F'.' '{print $4}')
dhcp_client_ip_octet='$dhcp_ip_octet'+1
dhcp_client_ip=$('$dhcp_ip' | sed 's/\.[0-9]*$/.${dhcp_client_ip_octet}/')
echo 'client  IN     A     ${dhcp_client_ip}' >> '${forward_file}'
echo 'www     IN     A     ${dhcp_client_ip}' >> '${forward_file}'

# Configure the DNS server's reverse zone configuration file.
forward_file='reverse.${dhcp_name}'
sudo cp /etc/bind/'${forward_file}' /etc/bind/'${reverse_file}'
sed -r '13/s/(.{16})(.{3})/\1PTR/' '${reverse_file}'
sed -r '13/s/(.{23})(.*)/\1${dhcp_name}./' '${reverse_file}'
echo '11      IN     PTR   server.${dhcp_name}.' >> '${reverse_file}'
echo '12      IN     PTR   server.${dhcp_name}.' >> '${reverse_file}'

# Check the above configurations for errors.
sudo named-checkconf -z /etc/bind/named.conf
sudo named-checkconf -z /etc/bind/named.conf.local
sudo named-checkzone forward /etc/bind/forward.'{$dhcp_name}'
sudo named-checkzone reverse /etc/bind/reverse.'{$dhcp_name}'

# Configure a firewall rule for the DNS server.
fire_stat=$(sudo ufw status | awk -F' ' '{print $2}')
if fire_stat == 'inactive'
then
	sudo ufw enable
fi
sudo ufw allow bind9
sudo ufw status

# Start the DNS server.
sudo systemctl start bind9
sudo chown -R bind:bind /etc/bind
sudo chmod -R 755 /etc/bind

bind_array=('restart' 'enable' '--no-pager status')
for i in ${bind_array[@]}
do
	sudo systemctl $i bind9
done

echo 'dns-search {$dhcp_name}' >> /etc/network/interfaces
echo 'dns-nameserver {$dhcp_ip}' >> /etc/network/interfaces
echo 'nameserver {$dhcp_ip}' >> /etc/resolv.conf
echo 'search {$dhcp_name}' >> /etc/resolv.conf

sudo systemctl restart networking
sudo systemctl restart NetworkManager

# Verify the connectivity of the DNS server.
server, host, client
ping_array=('server' 'host' 'client')
for i in ${ping_array[@]}
do
	ping -c 5 $i
done
