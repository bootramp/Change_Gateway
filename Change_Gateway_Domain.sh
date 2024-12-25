#!/bin/bash

# ����� ���� ��� �� ����� ����
domain="MY_DOMAIN"

# ��ʝ�� ���� �� ����� ����
gateway="MY_IP"

# ����� ���� ����� ���� �� ��ʝ��
define_route() {
    local ip=$1
    local gw=$2

    # ����� ���� ����
    route_exists=$(ip route | grep "$ip via $gw")
    if [ -z "$route_exists" ]; then
        # ���� �� ����� ����
        ip route add $ip via $gw 2>/dev/null ||  ip route replace $ip via $gw
        echo "���� �� $ip �� ���� $gw ����� ��." 
    else
        echo "���� �� $ip �� ���� $gw �� ��� ���� ����." 
    fi
}

# ���� ������� ���� ��� � ��������� IP
echo "���� �� ��� $domain � ������ IP �� ��ʝ�� $gateway..."
while true; do
    # ����� IP �� ���� ���
    ip=$(ping -c 1 $domain | grep "PING" | awk -F'[()]' '{print $2}')

    if [[ -n "$ip" ]]; then
        echo "IP ���� ����� $domain: $ip"
        define_route $ip $gateway
    else
        echo "��� �� ����� IP ���� ����� $domain"
    fi

    # � ����� ��� ����
    sleep 1
done
