#!/bin/bash
#LVS DR模式初始化脚本
LVS_vip=10.20.10.10
mask='255.255.255.255'
dev=lo:0
case $1 in
start)
echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce
ifconfig $dev $LVS_vip netmask $mask broadcast $LVS_vip 
#route add -host $LVS_vip dev $dev
echo "RealServer Start OK"
;;
stop)
ifconfig $dev down
# route del $LVS_vip > /dev/null 2>&1
echo 0 > /proc/sys/net/ipv4/conf/all/arp_ignore
echo 0 > /proc/sys/net/ipv4/conf/lo/arp_ignore
echo 0 > /proc/sys/net/ipv4/conf/all/arp_announce
echo 0 > /proc/sys/net/ipv4/conf/lo/arp_announce
echo "RealServer Stopped"
;;
*)
echo "Usage: $(basename $0) start|stop"
exit 1
;;
esac