#!/bin/sh

# PHANTOMA - Router Semi dan penghubung ke Shibuya.


echo "=== CONFIG PHANTOMA ==="

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.18.18/30 dev eth0

ip link set eth1 up
ip -4 addr flush dev eth1
ip addr add 10.66.18.33/27 dev eth1

ip link set eth2 up
ip -4 addr flush dev eth2
ip addr add 10.66.18.21/30 dev eth2

echo 1 > /proc/sys/net/ipv4/ip_forward

ip route replace default via 10.66.18.17 dev eth0

ip route replace 10.66.19.0/26 via 10.66.18.22 dev eth2

echo "=== IP PHANTOMA ==="
ip -br -4 addr
echo "=== ROUTING PHANTOMA ==="
ip route
echo "=== IP FORWARD ==="
cat /proc/sys/net/ipv4/ip_forward