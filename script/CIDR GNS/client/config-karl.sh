#!/bin/sh

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.4.2/22 dev eth0
ip route replace default via 10.66.4.1 dev eth0

echo "=== KARL ==="
ip -br -4 addr
ip route
