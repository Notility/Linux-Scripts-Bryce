#!/bin/bash

iptables -F
#Flush All previous iptables rules
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

#Adds 8000 as only allowed port
iptables -A INPUT -p tcp --dport 8000 -j ACCEPT

#removes ssh for good measure >:D
iptables -A INPUT -p tcp --dport 22 -j DROP

# To delete any rule list otu the current rules by line number with:
#   iptables -L --line-numbers

# Then delete a specific line in a specific section with:
#   iptables -D $chain $linenumber

#Saves for startup
iptables-save