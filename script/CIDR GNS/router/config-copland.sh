#!/bin/sh

# COPLAND - Router gateway Masayuki dan Juri.


echo "=== CONFIG COPLAND ==="

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.0.19/29 dev eth0

ip link set eth1 up
ip -4 addr flush dev eth1
ip addr add 10.66.2.1/23 dev eth1

ip link set eth2 up
ip -4 addr flush dev eth2
ip addr add 10.66.0.65/26 dev eth2

echo 1 > /proc/sys/net/ipv4/ip_forward

ip route replace default via 10.66.0.17 dev eth0

echo "=== IP COPLAND ==="
ip -br -4 addr
echo "=== ROUTING COPLAND ==="
ip route
echo "=== IP FORWARD ==="
cat /proc/sys/net/ipv4/ip_forward