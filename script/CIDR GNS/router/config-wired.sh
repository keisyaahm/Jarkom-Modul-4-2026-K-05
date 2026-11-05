#!/bin/sh

# WIRED - Router backbone yang menghubungkan seluruh cabang.


echo "=== CONFIG WIRED ==="

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.24.130/30 dev eth0

ip link set eth1 up
ip -4 addr flush dev eth1
ip addr add 10.66.22.65/30 dev eth1

ip link set eth2 up
ip -4 addr flush dev eth2
ip addr add 10.66.0.17/29 dev eth2

ip link set eth3 up
ip -4 addr flush dev eth3
ip addr add 10.66.18.1/30 dev eth3

echo 1 > /proc/sys/net/ipv4/ip_forward

ip route replace default via 10.66.24.129 dev eth0

ip route replace 10.66.0.0/28 via 10.66.0.20 dev eth2
ip route replace 10.66.8.0/22 via 10.66.0.20 dev eth2

ip route replace 10.66.0.64/26 via 10.66.0.19 dev eth2
ip route replace 10.66.2.0/23 via 10.66.0.19 dev eth2

ip route replace 10.66.4.0/22 via 10.66.0.18 dev eth2

ip route replace 10.66.16.0/22 via 10.66.18.2 dev eth3

ip route replace 10.66.20.0/22 via 10.66.22.66 dev eth1

echo "=== IP WIRED ==="
ip -br -4 addr
echo "=== ROUTING WIRED ==="
ip route
echo "=== IP FORWARD ==="
cat /proc/sys/net/ipv4/ip_forward