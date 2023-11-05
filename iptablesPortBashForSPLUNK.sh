#!/bin/bash
####YOU MUST RUN THIS AS SUDO


iptables -F
#Flush All previous iptables rules
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

#Adds Splunk Ports
iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
iptables -A INPUT -p tcp --dport 8065 -j ACCEPT
iptables -A INPUT -p tcp --dport 8191 -j ACCEPT
iptables -A INPUT -p tcp --dport 8865 -j ACCEPT

#removes ssh for good measure >:D
iptables -A INPUT -p tcp --dport 22 -j DROP

# To delete any rule list otu the current rules by line number with:
#   iptables -L --line-numbers

# Then delete a specific line in a specific section with:
#   iptables -D $chain $linenumber

#Saves for startup
iptables-save > /etc/sysconfig/iptables
service iptables save
service iptables restart