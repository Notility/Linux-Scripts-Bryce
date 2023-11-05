import os
import time
import sys

print("Select an option:")
print("1. List all active connections")
print("2. Clear all cron jobs")
print("3. Stop an Upstart service")
print("4. Stop a SysV service")
print("5. List and kill TCP connections")
print("6. Kill active pts/tty")
print("7. reset firewall to defaults (80)")
print("8. to set up a tftp server")

choice = raw_input("Enter your choice: ")

if choice == "1":
    os.system("ss")
elif choice == "2":
    cron = str(raw_input("Do you want to remove all cron jobs? Y/N: "))
    if cron.lower() == str("y"):
        try:
            os.chdir("/var/spool/cron")
            for user in os.listdir("."):
                with open(user, "w") as f:
                    f.write("")
                print("Cleared cron jobs for user: " + user)
            print("All cron jobs cleared")
        except OSError as e:
            print("Error clearing cron jobs:", e)
elif choice == "3":
    while True:
        print("Current Upstart services:")
        os.system("service --status-all")
        upchoice = raw_input("Enter the name of a service to stop (or 'n' to exit): ")
        if upchoice.lower() == "n":
            break
        upcommand = "sudo service " + upchoice + " stop"
        try:
            status = os.system(upcommand)
            if status == 0:
                print("Service stopped successfully")
            else:
                print("Error stopping service")
        except OSError as e:
            print("Error stopping service:", e)
elif choice == "4":
    while True:
        print("Current SysV services:")
        os.system("sudo initctl list")
        upchoice = raw_input("Enter the name of a service to stop (or 'n' to exit): ")
        if upchoice.lower() == "n":
            break
        upcommand = "sudo killall " + upchoice
        try:
            status = os.system(upcommand)
            if status == 0:
                print("Service stopped successfully")
            else:
                print("Error stopping service")
        except OSError as e:
            print("Error stopping service:", e)
elif choice == "5":
    print("Listing TCP connections")
    os.system("ss | grep tcp")
    tcpkill=raw_input("If you want to kill all connections from IP enter Y/N: ")
    if tcpkill.lower() == "y":
        ip = raw_input("Enter the IP address: ")
        os.system("sudo tcpkill host {}".format(ip))
        os.system("tcpkill -i eth0 port 22")
        print("killing all ssh connections if any")
elif choice == "6":
    print("Listing active pts/tty")
    os.system("ps aux | grep sh")
    ptskill = raw_input("If you want to kill a pts/tty enter Y/N: ")
    if ptskill.lower() == "y":
        ptsnum = raw_input("Enter the pts/tty number: ")
        os.system("sudo kill -9 {}".format(ptsnum))
elif choice == "7":
    print("Resting firewall back to default ports (80)")
    print("Resting UFW")
    os.system("ufw reset")
    os.system("ufw allow 80")
    os.system("sudo ufw default deny outgoing")
    os.system("sudo ufw default deny incoming")
    os.system("ufw enable")
elif choice == "8":
    tftp=raw_input("install tftp? y/n: ")
    print("ok installed tftp")
    os.system("sudo apt-get install tftpd-hpa -y")
    edit= raw_input("Clearing /etc/default/tftpd-hpa in 10 seconds ")
    time.sleep(10)
    os.system('echo TFTP_USERNAME="tftp" >> /etc/default/tftpd-hpa')
    os.system('echo TFTP_DIRECTORY="/var/lib/tftpboot" >> /etc/default/tftpd-hpa')
    os.system('echo TFTP_ADDRESS="0.0.0.0:69" >> /etc/default/tftpd-hpa')
    os.system('echo TFTP_OPTIONS="--secure" >> /etc/default/tftpd-hpa')
    os.system("sudo chmod -R 755 /var/lib/tftpboot/")
    os.system("sudo chown -R tftp:tftp /var/lib/tftpboot/")
    os.system("sudo ufw deny 69/udp")
    os.system("sudo ufw allow 69/tcp")
    os.system("sudo service tftpd-hpa restart")

else:
    print("Invalid choice")
