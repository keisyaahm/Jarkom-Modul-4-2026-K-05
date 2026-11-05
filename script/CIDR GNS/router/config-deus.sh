#!/bin/sh

# DEUS - Router Lillith/Specter dan penghubung ke Protocol7.


echo "=== CONFIG DEUS ==="

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.18.6/30 dev eth0

ip link set eth1 up
ip -4 addr flush dev eth1
ip addr add 10.66.18.129/25 dev eth1

ip link set eth2 up
ip -4 addr flush dev eth2
ip addr add 10.66.18.9/30 dev eth2

echo 1 > /proc/sys/net/ipv4/ip_forward

ip route replace default via 10.66.18.5 dev eth0

ip route replace 10.66.18.8/29 via 10.66.18.10 dev eth2
ip route replace 10.66.18.16/28 via 10.66.18.10 dev eth2
ip route replace 10.66.18.32/27 via 10.66.18.10 dev eth2
ip route replace 10.66.18.64/26 via 10.66.18.10 dev eth2
ip route replace 10.66.19.0/26 via 10.66.18.10 dev eth2

echo "=== IP DEUS ==="
ip -br -4 addr
echo "=== ROUTING DEUS ==="
ip route
echo "=== IP FORWARD ==="
cat /proc/sys/net/ipv4/ip_forward