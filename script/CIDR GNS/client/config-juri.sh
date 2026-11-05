#!/bin/sh

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.0.66/26 dev eth0
ip route replace default via 10.66.0.65 dev eth0

echo "=== JURI ==="
ip -br -4 addr
ip route
