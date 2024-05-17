# snmp_agentAutoInstall
auto script for installing net-snmp agent, open specific IP and port for monitoring. This script gonna use v2c for now , maybe can add v3 feature later

# Usage syntax : 
<script goes here> <monitor 's IP> <community string>
# Requirement :
* Can be used on some common OS (Ubuntu, CentOS, RedHat,...) 
* Can change firewall and open port for IP of the monitor 's host to access
#Direction :
* Check OS and based on the OS , use proper packet manager to update repo and install net-snmp
* Change snmp config file for the community string and rule for IP
* Change firewall rules to allow access from monitor host

