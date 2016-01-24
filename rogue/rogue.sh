#This bash script will help with setup of the dhcp server and configuration
#!/bin/bash

echo "We Shall Begin"

#collects system ip
echo "What is the IP address of your current System?"
read systemIP 

#collects subnet mask
echo "What is the subnet mask of the network you want to create? ex: 255.255.255.0"
read subnet_mask

#collects default gateway address
echo "What is the network subnet that you will create? ex: 192.168.1.0"
read network_mask

#collects local network card name
echo "What is network card name that you will create the AP on"
read AP_NIC_Name

#collects local NIC name
echo "What is the name of the NIC you are connected to the internet through"
read remote_nic


#collects name for ssid
echo "What would you like to call your ssid"
read ssid


echo "System IP:      $systemIP"
echo "Subnet mask:    $subnet_mask"
echo "Network mask:   $network_mask"
echo "AP NIC name:    $AP_NIC_Name"
echo "Local NIC Name: $local_nic"
echo "Remote NIC Name $remote_nic"
echo "SSID:           $ssid"



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

echo scripts > /etc/default/isc-dhcp-server
echo INTERFACES="at0" >> /etc/default/isc-dhcp-server



