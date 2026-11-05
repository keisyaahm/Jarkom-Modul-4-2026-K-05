#!/bin/sh

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.18.67/26 dev eth0
ip route replace default via 10.66.18.65 dev eth0

echo "=== HODGESON ==="
ip -br -4 addr
ip route
