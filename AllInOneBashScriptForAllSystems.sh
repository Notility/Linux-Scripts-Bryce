#!/bin/bash
####YOU MUST RUN THIS AS SUDO
if [ "$EUID" -ne 0 ]
  then echo "run as root first big man then we will see"
  exit
fi


# List of systems
systems=("Splunk (CentOS 6)" "Debian 8.5" "Ubuntu 14.04.2" "Ubuntu Desktop 12.04" "CentOS 7" "Fedora 21")

# Display the available systems with numbers
echo "Available Systems:"
for i in "${!systems[@]}"; do
  echo "$((i+1)). ${systems[i]}"
done
echo "Before running this script please verify that you have changed the password to your system to something that is secure"
# Ask the user to select a system by number
read -p "Select a system by entering the corresponding number: " selection

# Validate the user's input
if [[ $selection =~ ^[0-9]+$ ]]; then
  if ((selection >= 1 && selection <= ${#systems[@]})); then
    selected_system="${systems[selection-1]}"
    echo "You selected: $selected_system"

    # Perform actions based on the selected system
    case $selected_system in
      "Splunk (CentOS 6)")
        #Flush All previous iptables rules
        iptables -F

        ##Loopback traffic
        iptables -P INPUT -i lo -j ACCEPT

        #Adds Splunk Ports
        iptables -A INPUT -p tcp --dport 8000 -j ACCEPT

        #Allow ICMP requests from internal network at a limit in order to prevent ICMP flooding in the case that another system has been compromised
        iptables -A INPUT -p icmp --icmp-type 8 -m limit --limit 4/second -s 172.20.240.0/24 -j ACCEPT
        iptables -A INPUT -p icmp --icmp-type 8 -m limit --limit 4/second -s 172.20.241.0/24 -j ACCEPT
        iptables -A INPUT -p icmp --icmp-type 8 -m limit --limit 4/second -s 172.20.242.0/24 -j ACCEPT

        #removes ssh for good measure >:D
        iptables -A INPUT -p tcp --dport 22 -j DROP

        #Drop all other incomming traffic
        iptables -A INPUT -j drop
        # To delete any rule list otu the current rules by line number with:
        #   iptables -L --line-numbers

        # Then delete a specific line in a specific section with:
        #   iptables -D $chain $linenumber

        #Saves for startup
        iptables-save > /etc/sysconfig/iptables
        iptables-save
        service iptables save
        service iptables restart

        #Enable on startup
        chkconfig iptables on

        #Removes and turns off SSH if it exists
        if rpm -q openssh-server; then
          yum -y remove openssh-server
          yum -y remove openssh-clients
          chkconfig sshd off
          service sshd stop
        fi

        #Enable SELinux
        setenforce 1

        while IFS=: read -r username _; do
            if [ "$username" != "root" ]; then
                usermod -s /sbin/nologin "$username"
                echo "Bash shell access restricted for user: $username"
            fi
        done < /etc/passwd


        reboot
        ;;
      "Debian 8.5")
        # Add your iptables rules
        iptables -A INPUT -p udp --dport 53 -j ACCEPT
        iptables -A INPUT -p tcp --dport 53 -j ACCEPT
        iptables -A INPUT -p udp --dport 123 -j ACCEPT

        # Save the iptables rules to a file
        iptables-save > /etc/iptables-rules

        # Configure system to execute this script during startup
        echo "#!/bin/bash" > /etc/rc.local
        echo "/sbin/iptables-restore < /etc/iptables-rules" >> /etc/rc.local
        echo "exit 0" >> /etc/rc.local

        # Make the script executable
        chmod +x /etc/rc.local

        # Display a message
        echo "iptables rules have been configured, saved, and set to load at startup."

        # Reboot the system to apply the changes
        reboot
        ;;
      "Ubuntu 14.04.2")
        # Add your actions for Ubuntu 14.04.2 here
        echo "Perform actions for Ubuntu 14.04.2"
        ;;
      "Ubuntu Desktop 12.04")
        # Add your actions for Ubuntu Desktop 12.04 here
        echo "Perform actions for Ubuntu Desktop 12.04"
        ;;
      "CentOS 7")
        # Add your actions for CentOS 7 here
        echo "Perform actions for CentOS 7"
        ;;
      "Fedora 21")
        # Add your actions for Fedora 21 here
        echo "Perform actions for Fedora 21"
        ;;
    esac
  else
    echo "Invalid selection. Please enter a valid number."
  fi
else
  echo "Invalid input. Please enter a valid number."
fi
