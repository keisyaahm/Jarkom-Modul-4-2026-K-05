#!/bin/sh

# PROTOCOL7 - Router Chisa/Hodgeson dan penghubung ke Knights.


echo "=== CONFIG PROTOCOL7 ==="

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.18.10/30 dev eth0

ip link set eth1 up
ip -4 addr flush dev eth1
ip addr add 10.66.18.65/26 dev eth1

ip link set eth2 up
ip -4 addr flush dev eth2
ip addr add 10.66.18.13/30 dev eth2

echo 1 > /proc/sys/net/ipv4/ip_forward

ip route replace default via 10.66.18.9 dev eth0

ip route replace 10.66.18.16/28 via 10.66.18.14 dev eth2
ip route replace 10.66.18.32/27 via 10.66.18.14 dev eth2
ip route replace 10.66.19.0/26 via 10.66.18.14 dev eth2

echo "=== IP PROTOCOL7 ==="
ip -br -4 addr
echo "=== ROUTING PROTOCOL7 ==="
ip route
echo "=== IP FORWARD ==="
cat /proc/sys/net/ipv4/ip_forward