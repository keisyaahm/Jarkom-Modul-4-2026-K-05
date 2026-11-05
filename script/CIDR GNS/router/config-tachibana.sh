#!/bin/sh

# TACHIBANA - Router Collective/Ghost dan penghubung ke Deus.


echo "=== CONFIG TACHIBANA ==="

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.18.2/30 dev eth0

ip link set eth1 up
ip -4 addr flush dev eth1
ip addr add 10.66.16.1/23 dev eth1

ip link set eth2 up
ip -4 addr flush dev eth2
ip addr add 10.66.18.5/30 dev eth2

echo 1 > /proc/sys/net/ipv4/ip_forward

ip route replace default via 10.66.18.1 dev eth0

ip route replace 10.66.18.0/23 via 10.66.18.6 dev eth2

echo "=== IP TACHIBANA ==="
ip -br -4 addr
echo "=== ROUTING TACHIBANA ==="
ip route
echo "=== IP FORWARD ==="
cat /proc/sys/net/ipv4/ip_forward