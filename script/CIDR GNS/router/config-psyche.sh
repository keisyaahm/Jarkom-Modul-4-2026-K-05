#!/bin/sh

# PSYCHE - Router gateway Karl dan Lin.


echo "=== CONFIG PSYCHE ==="

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.0.18/29 dev eth0

ip link set eth1 up
ip -4 addr flush dev eth1
ip addr add 10.66.4.1/22 dev eth1

echo 1 > /proc/sys/net/ipv4/ip_forward

ip route replace default via 10.66.0.17 dev eth0

echo "=== IP PSYCHE ==="
ip -br -4 addr
echo "=== ROUTING PSYCHE ==="
ip route
echo "=== IP FORWARD ==="
cat /proc/sys/net/ipv4/ip_forward