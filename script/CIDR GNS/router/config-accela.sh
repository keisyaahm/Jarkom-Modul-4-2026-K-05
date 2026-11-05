#!/bin/sh

# ACCELA - Router gateway OmniPresence dan Denpa.


echo "=== CONFIG ACCELA ==="

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.0.10/30 dev eth0

ip link set eth1 up
ip -4 addr flush dev eth1
ip addr add 10.66.8.1/22 dev eth1

echo 1 > /proc/sys/net/ipv4/ip_forward

ip route replace default via 10.66.0.9 dev eth0

echo "=== IP ACCELA ==="
ip -br -4 addr
echo "=== ROUTING ACCELA ==="
ip route
echo "=== IP FORWARD ==="
cat /proc/sys/net/ipv4/ip_forward