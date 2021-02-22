#!/bin/bash

#example: ./add_delay_rule.sh 10.244.1.0 10.244.3.0 <delay1> <delay2>

ip1=$1
ip2=$2
delay1=$3
delay2=$4
dis=1 #echo $delay/5 | bc`
echo "ip1 = $ip1, ip2 = $ip2, delay1 = $delay1, delay2 = $delay2, dis = $dis"

sudo tc qdisc del dev flannel.1 root
sudo tc qdisc add dev flannel.1 root handle 1: prio priomap 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
sudo tc qdisc add dev flannel.1 parent 1:2 handle 20: netem delay ${delay1}ms ${dis}ms distribution normal
sudo tc qdisc add dev flannel.1 parent 1:3 handle 30: netem delay ${delay2}ms ${dis}ms distribution normal
sudo tc filter add dev flannel.1 protocol ip parent 1:0 u32 match ip dst $ip1/24 flowid 1:2
sudo tc filter add dev flannel.1 protocol ip parent 1:0 u32 match ip dst $ip2/24 flowid 1:3
