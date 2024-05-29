#!/bin/bash

install_net_snmp() {
    if command -v apt > /dev/null; then
        sudo apt update
        sudo apt install -y net-snmp
    elif command -v yum > /dev/null; then
        sudo yum update
        sudo yum install -y net-snmp
    else
        echo "Unsupported package manager"
        exit 1
    fi
}

# Function to change SNMP configuration file
change_snmp_config() {
    sudo sed -i 's/^com2sec notConfigUser  default       public/com2sec notConfigUser  default       your_community_string/' /etc/snmp/snmpd.conf
    sudo sed -i '/rocommunity public  default    -V systemonly/d' /etc/snmp/snmpd.conf
    sudo systemctl restart snmpd
}

# Function to change firewall rules to allow access from monitor host
change_firewall_rules() {
    if command -v ufw > /dev/null; then
        sudo ufw allow from monitor_host_ip to any port 161
        sudo ufw reload
    elif command -v firewall-cmd > /dev/null; then
        sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="monitor_host_ip" port protocol="udp" port="161" accept'
        sudo firewall-cmd --reload
    else
        echo "Unsupported firewall configuration tool"
        exit 1
    fi
}

# Main script
install_net_snmp
change_snmp_config
change_firewall_rules

echo "Auto installation and configuration completed successfully."
