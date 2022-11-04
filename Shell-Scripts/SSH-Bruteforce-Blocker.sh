#!/bin/bash
# Project name: SSH Bruteforce Blocker
# Version: 1.1
# Written by: KsrvcO
# This tool using ssh log files and detect bruteforce attacks and then block them.
# Execute this tool every 1 minute via crontab on your server for detect attacks using ssh log file.
# This tool can detect any ip addresses that trying more than 10 times for login into ssh service and gets failure authentication error.
# Run this tool every minute using crontab:
# chmod +x /root/SSH-Bruteforce-Blocker.sh
# * * * * * /root/SSH-Bruteforce-Blocker.sh

reset
wdir="/tmp/SSHBlocker"
logdir="/var/log/auth.log"
mkdir -p $wdir
cat $logdir | \
grep "authentication failure" | \
grep "ruser" | \
awk ' { print $14 } ' | \
cut -d "=" -f2 | \
uniq -c | \
sort -u | \
awk '$1 > 10' | \
awk '{ print $2 }' | \
sort -u > $wdir/be-block.txt
for i in $(cat $wdir/be-block.txt)
do
    iptables -t filter -C INPUT -p tcp -m comment --comment "SSHBruteForce" -s $i -j DROP || iptables -t filter -I INPUT -p tcp -m comment --comment "SSHBruteForce" -s $i -j DROP
done
/usr/sbin/iptables-save | grep "SSHBruteForce" | awk '{ print $4 }' | cut -d "/" -f1 | sort -u >> /root/temp-blocked.txt
cat /root/temp-blocked.txt | sort -u > /root/ssh-blocked.txt
rm -rf /root/temp-blocked.txt
rm -rf $wdir
exit
