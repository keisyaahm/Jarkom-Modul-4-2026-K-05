#!/bin/sh

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.19.3/26 dev eth0
ip route replace default via 10.66.19.1 dev eth0

echo "=== MIKA ==="
ip -br -4 addr
ip route
