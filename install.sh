#!/bin/bash
# $Id$
#
# sCRiPTz-TEAM -- Auto ServerStats installer, fixed, updated

apt-get install serverstats
cd /usr/share/doc/serverstats
cp examples/apache.conf /etc/apache2/sites-available/serverstats.conf
a2ensite serverstats.conf
service apache2 reload
chown -R www-data:www-data /usr/share/serverstats/
chmod -R 777 /usr/share/serverstats/*
cd /usr/share/serverstats/
php update.php
cd rrd
chmod 777 /usr/share/serverstats/rrd/*
mkdir /home/rrd_traffic/
chmod 777 /home/rrd_traffic/
rm /usr/share/doc/serverstats/examples/traffic.sh
cd /usr/share/doc/serverstats/examples/
wget https://raw.githubusercontent.com/scriptzteam/RRD-ServerStats-Installer/master/fixed-traffic.sh
mv fixed-traffic.sh traffic.sh
#vi /usr/share/doc/serverstats/examples/traffic.sh 
#LOGPATH="/home/rrd_traffic"
#CHAINLIST="all-traffic"
#SLEEP_BIN="/bin/sleep"
#AWK_BIN="/usr/bin/awk"
#${SLEEP_BIN} 5
chmod 777 /usr/share/doc/serverstats/examples/traffic.sh
#for iptables logging
iptables -N traffic-output
iptables -F traffic-output
iptables -N all-traffic
iptables -F all-traffic 
iptables -A INPUT -j all-traffic
iptables -A OUTPUT -j all-traffic
iptables -A all-traffic -j traffic-output
sh /usr/share/doc/serverstats/examples/traffic.sh
chmod 777 /home/rrd_traffic/*
#crontab -e
#backup cron, just in case :D
cp /var/spool/cron/crontabs/root /root/root.backup
#add cron
croncmd="php /usr/share/serverstats/update.php > /dev/null 2>&1"
cronjob="* * * * * $croncmd"
( crontab -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -

croncmd="sh /usr/share/doc/serverstats/examples/traffic.sh > /dev/null 2>&1"
cronjob="*/1 * * * * $croncmd"
( crontab -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -

#* * * * * php /usr/share/serverstats/update.php > /dev/null 2>&1
#*/1 * * * * sh /usr/share/doc/serverstats/examples/traffic.sh > /dev/null 2>&1
