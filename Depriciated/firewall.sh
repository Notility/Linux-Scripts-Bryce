#!/usr/bin/bash
which apt && {
    echo "Apt Found!"
    apt install --yes firewalld
}

which yum && {
    echo "Yum Found!"
    yum install -y firewalld
}

systemctl enable --now firewalld

echo "test"
if [ -d /etc/firewalld/zones ]; then
    rm -rf /etc/firewalld/zones/*
    echo "Firewalld path is /etc/firewalld"
elif [ -d /usr/etc/firewalld/zones ]; then
    rm -rf /usr/etc/firewalld/zones/*
    echo "Firewalld path is /usr/etc/firewalld"
else
    echo "Firewalld not found"
    exit 1
fi

firewall-cmd --complete-reload
firewall-cmd --remove-service=ssh
echo "Rules have been cleared and ssh has been removed"

select opt in "ecomm" "web" "splunk" "dns" "mail" "workstation" "clear"; do
    case $opt in
        "ecomm")
            echo "You chose ecomm"
            firewall-cmd --add-port=80/tcp
            firewall-cmd --add-port=3306/tcp
            break
            ;;
        "web")
            echo "You chose web"
            firewall-cmd --add-port=80/tcp
            firewall-cmd --add-port=3306/tcp
            break
            ;;
        "splunk")
            echo "You chose splunk"
            firewall-cmd --add-port=8089/tcp
            firewall-cmd --add-port=8865/tcp
            firewall-cmd --add-port=8000/tcp
            firewall-cmd --add-port=8191/tcp
            break
            ;;
        "dns")
            echo "You chose dns"
            firewall-cmd --add-port=53/tcp
            firewall-cmd --add-port=25/tcp
            firewall-cmd --add-port=111/tcp
            firewall-cmd --add-port=21/tcp
            firewall-cmd --add-port=953/tcp
            firewall-cmd --add-port=80/tcp
            break
            ;;
        "mail")
            echo "You chose mail"
            firewall-cmd --add-port=2049/tcp
            firewall-cmd --add-port=110/tcp
            firewall-cmd --add-port=111/tcp
            firewall-cmd --add-port=143/tcp
            firewall-cmd --add-port=25/tcp
            firewall-cmd --add-port=3306/tcp
            firewall-cmd --add-port=80/tcp
            break
            ;;
        "workstation")
            echo "You chose workstation"
            break
            ;;
        "clear")
            echo "You have cleared all firewall rules"
            break
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
