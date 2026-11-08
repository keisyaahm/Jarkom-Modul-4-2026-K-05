#!/bin/sh

# CYBERIA - Router utama, gateway ke NAT GNS3, routing CIDR, dan NAT.


echo "=== CONFIG CYBERIA ==="

ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 192.168.122.25/24 dev eth0
ip route replace default via 192.168.122.1 dev eth0

ip link set eth1 up
ip -4 addr flush dev eth1
ip addr add 10.66.24.1/25 dev eth1

ip link set eth2 up
ip -4 addr flush dev eth2
ip addr add 10.66.24.129/30 dev eth2

echo 1 > /proc/sys/net/ipv4/ip_forward

ip route replace 10.66.0.0/19 via 10.66.24.130 dev eth2

if command -v iptables >/dev/null 2>&1; then
    iptables -P FORWARD ACCEPT

    iptables -t nat -D POSTROUTING \
        -s 10.66.0.0/19 \
        -o eth0 \
        -j MASQUERADE 2>/dev/null || true

    iptables -t nat -A POSTROUTING \
        -s 10.66.0.0/19 \
        -o eth0 \
        -j MASQUERADE
fi

echo "=== IP CYBERIA ==="
ip -br -4 addr
echo "=== ROUTING CYBERIA ==="
ip route
echo "=== IP FORWARD ==="
cat /proc/sys/net/ipv4/ip_forward
echo "=== NAT ==="
iptables -t nat -L POSTROUTING -n -v