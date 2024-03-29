#!/bin/bash

source ./bin/scripts/common.sh

sed -r -i 's/^#DNSSEC=.*$/DNSSEC=yes/m' /etc/systemd/resolved.conf
sed -r -i 's/^#DNSOverTLS=.*$/DNSOverTLS=yes/m' /etc/systemd/resolved.conf
sed -r -i 's/^#Cache=.*$/Cache=yes/m' /etc/systemd/resolved.conf
sed -r -i 's/^#DNS=.*$/DNS=1.1.1.2#cloudflare-dns.com 2606:4700:4700::1112#cloudflare-dns.com/m' /etc/systemd/resolved.conf
sed -r -i 's/^#FallbackDNS=.*$/FallbackDNS=8.8.4.4#dns.google 2001:4860:4860::8844#dns.google/m' /etc/systemd/resolved.conf
systemctl restart systemd-resolved

if [ "$(timeout 10 ping -c1 google.com 2>/dev/null)" = "" ]; then
  sed -r -i 's/^DNSSEC=.*$/DNSSEC=allow-downgrade/m' /etc/systemd/resolved.conf
  systemctl restart systemd-resolved
fi

if [ "$(timeout 10 ping -c1 google.com 2>/dev/null)" = "" ]; then
  sed -r -i 's/^DNSSEC=/#DNSSEC=/m' /etc/systemd/resolved.conf
  systemctl restart systemd-resolved
fi


curl-install-if-ok "https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/modprobe.d/30_security-misc.conf" "/etc/modprobe.d/30_security-misc.conf"

curl-install-if-ok "https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_security-misc.conf" "/etc/sysctl.d/30_security-misc.conf"
if [ -s "/etc/sysctl.d/30_security-misc.conf" ]; then
  sed -i 's/kernel.yama.ptrace_scope=2/kernel.yama.ptrace_scope=1/g' "/etc/sysctl.d/30_security-misc.conf"
  sed -i 's/net.ipv4.icmp_echo_ignore_all=1/net.ipv4.icmp_echo_ignore_all=0/g' "/etc/sysctl.d/30_security-misc.conf"
  sed -i 's/net.ipv6.icmp_echo_ignore_all=1/net.ipv6.icmp_echo_ignore_all=0/g' "/etc/sysctl.d/30_security-misc.conf"
fi

curl-install-if-ok "https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_silent-kernel-printk.conf" "/etc/sysctl.d/30_silent-kernel-printk.conf"
curl-install-if-ok "https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_security-misc_kexec-disable.conf" "/etc/sysctl.d/30_security-misc_kexec-disable.conf"
curl-install-if-ok "https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf" "/etc/chrony.conf"


#todo: remember to add other securety apps
