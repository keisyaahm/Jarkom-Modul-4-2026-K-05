#!/bin/sh

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.22.2/26 dev eth0
ip route replace default via 10.66.22.1 dev eth0

echo "=== TARO ==="
ip -br -4 addr
ip route
