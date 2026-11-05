#!/bin/sh

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.20.2/24 dev eth0
ip route replace default via 10.66.20.1 dev eth0

echo "=== ALICE ==="
ip -br -4 addr
ip route
