#!/bin/sh

# SCHUMANN - Router gateway Akashic dan penghubung Accela.


echo "=== CONFIG SCHUMANN ==="

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.0.20/29 dev eth0

ip link set eth1 up
ip -4 addr flush dev eth1
ip addr add 10.66.0.1/29 dev eth1

ip link set eth2 up
ip -4 addr flush dev eth2
ip addr add 10.66.0.9/30 dev eth2

echo 1 > /proc/sys/net/ipv4/ip_forward

ip route replace default via 10.66.0.17 dev eth0

ip route replace 10.66.8.0/22 via 10.66.0.10 dev eth2

echo "=== IP SCHUMANN ==="
ip -br -4 addr
echo "=== ROUTING SCHUMANN ==="
ip route
echo "=== IP FORWARD ==="
cat /proc/sys/net/ipv4/ip_forward