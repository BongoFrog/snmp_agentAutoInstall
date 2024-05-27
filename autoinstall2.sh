#!/bin/bash

install_net_snmp() {
    os=$(cat /etc/os-release | grep "^ID=" | cut -d'=' -f2 | tr -d '"')
    case $os in
        ubuntu)
            sudo apt update
            sudo apt install -y net-snmp
            ;;
        centos | rhel)
            sudo yum update
            sudo yum install -y net-snmp
            ;;
        *)
            echo "Unsupported OS"
            exit 1
            ;;
    esac
}

# Function to change SNMP configuration file
change_snmp_config() {
    sudo sed -i 's/^com2sec notConfigUser  default       public/com2sec notConfigUser  default       your_community_string/' /etc/snmp/snmpd.conf
    sudo sed -i '/rocommunity public  default    -V systemonly/d' /etc/snmp/snmpd.conf
    sudo systemctl restart snmpd
}

# Function to change firewall rules to allow access from monitor host
change_firewall_rules() {
    os=$(cat /etc/os-release | grep "^ID=" | cut -d'=' -f2 | tr -d '"')
    case $os in
        ubuntu)
            sudo ufw allow from monitor_host_ip to any port 161
            sudo ufw reload
            ;;
        centos | rhel)
            sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="monitor_host_ip" port protocol="udp" port="161" accept'
            sudo firewall-cmd --reload
            ;;
        *)
            echo "Unsupported OS"
            exit 1
            ;;
    esac
}

# Main script
install_net_snmp
change_snmp_config
change_firewall_rules

echo "Auto installation and configuration completed successfully."
