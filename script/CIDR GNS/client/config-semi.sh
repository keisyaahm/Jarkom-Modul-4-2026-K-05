#!/bin/sh

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.18.34/27 dev eth0
ip route replace default via 10.66.18.33 dev eth0

echo "=== SEMI ==="
ip -br -4 addr
ip route
