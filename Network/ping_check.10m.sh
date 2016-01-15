#!/bin/bash
# <bitbar.title>Ping Check</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>gordon</bitbar.author>
# <bitbar.author.github>gordonrgw</bitbar.author.github>
# <bitbar.desc>uses nc to connect to server ports</bitbar.desc>
#
# just a quick hack for personal use, but someone may find useful..
# minimal error checking, so take care..
#
rm /tmp/ssmenu
work="<U+2705>"
error="‼️"
#echo "$work server status | length=15"
#echo "---"
#echo "gw bar | color=green | dropdown=false"
icon=$work
#define servers here, format - server_name:port1,port2 ....
server_list="server1:22,25 server2:22 server3:22 server4:22,80 server5:22,3128 www.google.com:80"
for each in $server_list
do
        server=`echo $each | awk -F \: '{print $1}'`
        ports=`echo $each | awk -F \: '{print $2}' | awk -F \, '{print $1" "$2" "$3" "$4" "$5}'`
#       echo $server $port
#       /usr/bin/nc -z $server $port
        for each in $ports
        do
        reply=`nc -zv $server $each 2>&1 | grep tcp`
        case $reply
        in
                nc*)
                        status="<U+1F534>"
                        status_color=red
                        icon=$error
                ;;
                Conn*)
                        status="<U+2705>"
                        status_color=green
                ;;
        esac
        echo "$status $server $each | color=$status_color length=30" >> /tmp/ssmenu
        done
        echo "---" >> /tmp/ssmenu
done
echo "$icon server status | size=14 color=$status_color length=20"
echo "---"
cat /tmp/ssmenu
