#!/bin/sh

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.18.26/29 dev eth0
ip route replace default via 10.66.18.25 dev eth0

echo "=== EIRI ==="
ip -br -4 addr
ip route
