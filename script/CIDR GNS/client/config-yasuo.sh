#!/bin/sh

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.21.2/24 dev eth0
ip route replace default via 10.66.21.1 dev eth0

echo "=== YASUO ==="
ip -br -4 addr
ip route
