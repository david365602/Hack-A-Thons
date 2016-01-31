#This bash script will help with setup of the dhcp server and configuration
#!/bin/bash

echo "We Shall Begin"

#collects system ip
read -p "What is the IP address of your current System: " systemIP
echo ""

read -p "Give an IP address for your other network <ex: 172.16.5.1>: " local_IP
echo ""

read -p "Give your dns IP address <ex: 172.16.5.1>
for multiple dns servers <ex: 172.16.5.1, 8.8.8.8>:" dns_server
echo ""

read -p "What is the subnet mask of the network you want to create? <ex: 255.255.255.0>" subnet_mask
echo ""

read -p "What is the network subnet that you will create? <ex: 192.168.1.0>: " network_mask
echo ""

read -p "Enter the range of IPs EXACTLY like this: <192.168.1.5 192.168.1.150>: " range
echo ""

read -p "Enter the broadcast address <ex: 192.168.1.255>: "broadcast
echo ""

#collects local network card name
read -p "What is network card name that you will create the AP on: " local_nic
echo ""

#collects local NIC name
read -p "What is the name of the NIC you are connected to the internet through<ex: eth0;wlan0;wlan1;etc>: " remote_nic
echo ""

#collects name for ssid
read -p "What would you like to call your ssid: " ssid
echo ""

echo "
Your system settings are:
System IP:        $systemIP
Local IP          $local_IP
Subnet mask:      $subnet_mask
Broadcast         $broadcast
DNS Server        $dns_server
Network mask:     $network_mask
Local NIC Name:   $local_nic
Remote NIC Name   $remote_nic
SSID:             $ssid
"
sleep 5


variable=0

while [ $variable -eq 0 ]; do
echo "Have you installed your dhcp server? (y/n)"
read answer1
	if [ $answer1 = "y" ] || [ $answer1 = "Y" ]; then
		echo "you have a dhcp server"
		variable=1
		echo "We can skip the dhcp installation"
		sleep 2
	elif [ $answer1 = "n" ] || [ $answer1 = "N" ]; then
		echo "you do not have a dhcp server"
		variable=1
		echo "installing dhcp server now"
		sleep 3
		apt-get update
		apt-get install isc-dhcp-server -y

	else
		echo "Please try again"
	fi
done

cp -v /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
echo scripts > /etc/default/isc-dhcp-server
echo INTERFACES="at0" >> /etc/default/isc-dhcp-server


cp -v /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
echo "Creating dhcp configuration file"
#dhcp configuration file
echo "authoritative;
ddns-update-style none;

default-lease-time 600;
max-lease-time 7200;

log-facility local7;

subnet $network_mask netmask $subnet_mask {
  range $range;
  option broadcast-address $broadcast-address; 
  option routers $local_IP; #our IP, for this senario
  option subnet-mask $subnet_mask; #subnet
  option domain-name \"$ssid\";
  option domain-name-servers $dns_server;
}" > /etc/dhcp/dhcpd.conf


#wifi settings change
airmon-ng check kill
airmon-ng start $local_nic
airmon-ng

echo "Enter the new name of your local_nic ex: wlan4mon"
read local_nic

#changes mac address and boostes dbm
ifconfig $local_nic down
iw set reg US
macchanger -r $local_nic
ifconfig $local_nic up
iwconfig $local_nic txpower 30
ifconfig $local_nic up

#EOF
