#!/bin/bash
####YOU MUST RUN THIS AS SUDO
if [ "$EUID" -ne 0 ]
  then echo "run as root first big man then we will see"
  exit
fi

#Flush All previous iptables rules
iptables -F

##Loopback traffic
iptables -P INPUT -i lo -j ACCEPT

#Adds Splunk Ports
iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
iptables -A INPUT -p tcp --dport 8065 -j ACCEPT
iptables -A INPUT -p tcp --dport 8191 -j ACCEPT
iptables -A INPUT -p tcp --dport 8865 -j ACCEPT

#Allow ICMP requests from internal network
iptables -A INPUT -p icmp -s 172.20.240.0/24 -j ACCEPT
iptables -A INPUT -p icmp -s 172.20.241.0/24 -j ACCEPT
iptables -A INPUT -p icmp -s 172.20.242.0/24 -j ACCEPT

#removes ssh for good measure >:D
iptables -A INPUT -p tcp --dport 22 -j DROP

#Drop all other incomming traffic
iptables -A INPUT -j REJECT
# To delete any rule list otu the current rules by line number with:
#   iptables -L --line-numbers

# Then delete a specific line in a specific section with:
#   iptables -D $chain $linenumber

#Saves for startup
iptables-save > /etc/sysconfig/iptables
service iptables save
service iptables restart

#Enable on startup
chkconfig iptables on