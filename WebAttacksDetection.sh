#!/bin/bash
# Tooll name: Web attacks detect via nginx log files
# Coded by: KsrvcO
# Tested on: Ubuntu server , Debian server
# This tool will save blocked C2 ips in /root/c2blocked.txt
# Make sure that iptables installed on your system.
# This is sample file and you can add extra payloads and parameters for detect web attacks.
# Add this script in crontab for execute automatically every 1 minute for example.

reset
output="/root/output"
db="/root/output/db"
mkdir -p /tmp/malwarec2
mkdir -p $output
mkdir -p $db
cp -r /var/log/nginx/access.log* /tmp/malwarec2
gzip -d /tmp/malwarec2/*.gz
cat /tmp/malwarec2/access.log* > /tmp/malwarec2/nginx.logs
rm -rf /tmp/malwarec2/access.log*
cat /tmp/malwarec2/nginx.logs | grep -e ".sh" \
-e "chmod" \
-e "/etc/" \
-e "wget" \
-e "/etc/passwd" \
-e "<script>" \
-e "alert" \
-e "/etc/shadow" \
-e "document.cookie" \
-e "order" \
-e "information_schema" \
-e "/proc" \
-e "%2Fproc" \
-e "%2Fetc%2Fpasswd" \
-e "%2Fetc%2Fshadow" \
-e "%3Cscript%3E" | \
awk '{ print $1 }' | \
sort -u > /tmp/malwarec2/tmp-block.txt
for i in $(cat /tmp/malwarec2/tmp-block.txt)
do
iptables -t filter -C INPUT -p tcp -m comment --comment "MalwareC2Detect" -s $i -j DROP || iptables -t filter -I INPUT -p tcp -m comment --comment "MalwareC2Detect" -s $i -j DROP
iptables -t filter -C INPUT -p udp -m comment --comment "MalwareC2Detect" -s $i -j DROP || iptables -t filter -I INPUT -p udp -m comment --comment "MalwareC2Detect" -s $i -j DROP
done
date > $output/c2blocked.txt
/usr/sbin/iptables-save | grep "MalwareC2Detect" | awk '{ print $4 }' | cut -d "/" -f1 | sort -u >> $output/c2blocked.txt
echo " " >> $output/c2blocked.txt
echo " " >> $output/c2blocked.txt
randomnumber=$(shuf -i 0-1000 -n 1)
cp -r $output/c2blocked.txt $db/$randomnumber.txt
rm -rf /tmp/malwarec2/nginx.logs
rm -rf /tmp/malwarec2
