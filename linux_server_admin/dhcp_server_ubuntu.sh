#!/bin/bash
# Update the OS.
sudo apt update

# Install the DHCP server.
sudo apt install isc-dhcp-server

# Install Net Tools and run IfConfig.
sudo apt install net-tools
ifconfig

# Select a network interface.
echo Enter the appropriate network interface (eth0, wlan0, ens3, enp0s3, etc.):
read -r "net_int"

# Configure the network interface as the IPv4 settings of the DHCP server.
sed -i '18s/^\(.\{14\}\)/\1${net_int}/' /etc/default/isc-dhcp-server

# Configure the DNS settings of the DHCP server.
echo Does your DNS server have a domain name? (Y/N)
read -r "dns_name_yn"
config_file="/etc/dhcp/dhcpd.conf"
if $dns_name_yn = "Y" || "y"
then
    echo Enter the domain name of the DNS server:
    read -r "dns_name"
    # Replace the default domain name of the DNS server.
    sed -r '10/s/(.{20})(.{11})/\1${dhcp_name}/' '${config_file}'
else
    # Comment the default domain name of the DNS server.
    sed -i '10 s/^/#/' '${config_file}'
fi

echo Does your DNS server have an IP address? (Y/N)
read -r "dns_ip_yn"
if $dns_ip_yn = "Y" || "y"
then
    echo Does your DNS server have 1 or 2 IP addresses?
    read -r "dns_ip_12"
	if $dns_ip_12 = "1"
    then
        # Replace the default first IP address of the DNS server.
	    echo Enter the IP address of the DNS server:
	    read -r "dns_ip_1"
        sed -r '11/s/(.{27})(.{15})/\1${dns_ip_1}/' '${config_file}'
        sed -E '11 s/^(.{42}).{17}(.*)/\1\2/' '${config_file}'
    else
        echo Enter the first IP address of the DNS server:
	    read -r "dns_ip_1"
        sed -r '11/s/(.{27})(.{15})/\1${dns_ip_1}/' '${config_file}'
        # Replace the default second IP address of the DNS server.
        echo Enter the second IP address of the DNS server:
	    read -r "dns_ip_2"
        sed -r '11/s/(.{44})(.{15})/\1${dns_ip_2}/' '${config_file}'
	fi
else
    # Comment the default IP address of the DNS server.
    sed -i '11 s/^/#/' '${config_file}'
fi

# Make the DHCP server the official DHCP server by un-commenting the authoritative directive.
sed -i '24 s/^#//' '${config_file}'

# Enable the subnet by un-commenting it.
for i in {45..54..1}
    do
        sed -i '${i} s/^#//' '${config_file}'
done

# Configure the subnet.
subnet_mask=$(ifconfig '$net_int' | awk -F' ' 'FNR == 2 {print $4}')
subnet_ip=$(ifconfig '$net_int' | awk -F' ' 'FNR == 2 {print $2}' | sed 's/\.[0-9]*$/.0/')

sed -r '45/s/(.{17})(.{15})/\1${subnet_mask}/' '${config_file}'
sed -r '45/s/(.{7})(.{8})/\1${subnet_ip}/' '${config_file}'

echo What will be the subnet range of the hosts (enter the number, not the IP address range)?
read -r "subnet_range"
first_host=$(ifconfig '$net_int' | awk -F' ' 'FNR == 2 {print $2}' | sed 's/\.[0-9]*$/.1/')
last_host=$(ifconfig '$net_int' | awk -F' ' 'FNR == 2 {print $2}' | sed 's/\.[0-9]*$/.${subnet_range}/')
sed -r '46/s/(.{6})(.{9})/\1${first_host}/' '${config_file}'
sed -r '46/s/(.{6})(.{9})/\1${last_host}/' '${config_file}'

# Configure the DNS settings of the subnet.
if $dns_ip_yn = "N" || "n"
    sed -i '47 s/^/#/' '${config_file}'
fi
if $dns_ip_12 = "1"
then
    sed -r '47/s/(.{26})(.{10})/\1${dns_ip_1}/' '${config_file}'
fi
if $dns_ip_12 = "2"
then
    sed -i '47s/^\(.\{37\}\)/\1${dns_ip_1}/' '${config_file}'
fi
if $dns_name_yn = "N" || "n"
then
    sed -i '48 s/^/#/' '${config_file}'
fi

# Configure a firewall rule for the DHCP server.
fire_stat=$(sudo ufw status | awk -F' ' '{print $2}')
if fire_stat == 'inactive'
then
	sudo ufw enable
fi
sudo ufw allow in on '$net_int' from any port 68 to any port 67 proto udp
sudo ufw status

dhcp_server_array=('enable' 'start' '--no-pager status')
for i in ${dhcp_server_array[@]}
do
	sudo systemctl $i isc-dhcp-server
done
