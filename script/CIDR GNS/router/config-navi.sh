#!/bin/sh

# NAVI - Router untuk Alice, Reika, Taro, Yasuo, Miho, Kuma.


echo "=== CONFIG NAVI ==="

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.22.66/30 dev eth0

ip link set eth1 up
ip -4 addr flush dev eth1
ip addr add 10.66.20.1/24 dev eth1

ip link set eth2 up
ip -4 addr flush dev eth2
ip addr add 10.66.22.1/26 dev eth2

ip link set eth3 up
ip -4 addr flush dev eth3
ip addr add 10.66.21.1/24 dev eth3

echo 1 > /proc/sys/net/ipv4/ip_forward

ip route replace default via 10.66.22.65 dev eth0

echo "=== IP NAVI ==="
ip -br -4 addr
echo "=== ROUTING NAVI ==="
ip route
echo "=== IP FORWARD ==="
cat /proc/sys/net/ipv4/ip_forward