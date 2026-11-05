#!/bin/sh

# SHIBUYA - Router gateway LAN Lain dan Mika.


echo "=== CONFIG SHIBUYA ==="

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.18.22/30 dev eth0

ip link set eth1 up
ip -4 addr flush dev eth1
ip addr add 10.66.19.1/26 dev eth1

echo 1 > /proc/sys/net/ipv4/ip_forward

ip route replace default via 10.66.18.21 dev eth0

echo "=== IP SHIBUYA ==="
ip -br -4 addr
echo "=== ROUTING SHIBUYA ==="
ip route
echo "=== IP FORWARD ==="
cat /proc/sys/net/ipv4/ip_forward