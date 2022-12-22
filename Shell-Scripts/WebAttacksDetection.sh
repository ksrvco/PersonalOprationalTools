#!/bin/bash
# Tooll name: Web attacks detect via nginx log files
# Coded by: KsrvcO
# Version: 1.2
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
	-e "document.domain" \
	-e "onbegin=prompt(1)" \
	-e "alert" \
	-e "script" \
	-e "onpointerenter" \
	-e "onauxclick" \
	-e "javascript" \
	-e "onclick" \
	-e "document.cookie" \
	-e "srcdoc" \
	-e "prompt" \
	-e "onerror" \
	-e "onload" \
	-e "onmouseover" \
	-e "OnPointerEnter" \
	-e "j%0A%0Davascript" \
	-e "localStorage" \
	-e "wget" \
	-e "curl" \
	-e "nc" \
	-e "netcat" \
	-e "/proc" \
	-e "gcc" \
	-e "onbegin%3Dprompt%281%29" \
	-e "j%250A%250Davascript" \
	-e "%2Fproc" \
	-e "onbegin%3Dprompt" \
	-e "chmod" \
	-e "/etc/" \
	-e "/etc/passwd" \
	-e "<script>" \
	-e "/etc/shadow" \
	-e "document.cookie" \
	-e "order" \
	-e "information_schema" \
	-e "/proc" \
	-e "%2Fproc" \
	-e "%2Fetc%2Fpasswd" \
	-e "%2Fetc%2Fshadow" \
	-e "%3Cscript%3E" \
	-e "%2Fetc%2F" \
	-e "%2Fetc%2Fpasswd" \
	-e "%3Cscript%3E" \
	-e "%2Fetc%2Fshadow" \
	-e "%2Fproc" \
	-e "/etc/aliases" \
	-e "/etc/anacrontab" \
	-e "/etc/hosts" \
	-e "/etc/resolv.conf" \
	-e "/proc/meminfo" \
	-e "/proc/cpuinfo" \
	-e "%2Fetc%2Faliases" \
	-e "%2Fetc%2Fanacrontab" \
	-e "%2Fetc%2Fhosts" \
	-e "%2Fetc%2Fresolv.conf" \
	-e "%2Fproc%2Fmeminfo" \
	-e "%2Fproc%2Fcpuinfo" \
	-e "/proc/self/environ" \
	-e "/proc/version" \
	-e "/etc/group" \
	-e "/etc/issue" \
	-e "%2Fproc%2Fversion" \
	-e "%2Fetc%2Fgroup" \
	-e "%2Fetc%2Fissue" | \
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