#!/bin/bash
#test to create organized text files

network_mask='192.168.1.55'
some="ifconfig"

echo "subnet $network_mask netmask 255.255.255.0 {
  range 192.168.1.1 192.168.1.10;
  option routers pepper.spices.org;
}" > text.txt
$some