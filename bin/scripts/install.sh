#!/bin/bash

source ./bin/scripts/common.sh

#* optimize package manager
if ! grep -R "^# Added for Speed" "/etc/dnf/dnf.conf"; then
  sudo sed -r -i 's/^best=(.*)$/best=True/m' "/etc/dnf/dnf.conf"
  #echo "fastestmirror=True" | sudo tee -a "/etc/dnf/dnf.conf"
  echo "max_parallel_downloads=10" | sudo tee -a "/etc/dnf/dnf.conf"
  echo "defaultyes=True" | sudo tee -a "/etc/dnf/dnf.conf"
  echo "keepcache=True" | sudo tee -a "/etc/dnf/dnf.conf"
  echo "install_weak_deps=False" | sudo tee -a "/etc/dnf/dnf.conf"
fi

sudo dnf -y update

#* install and remove apps
dnf -y install firewalld qemu-guest-agent tuned
dnf -y remove cifs-utils samba-common-libs samba-client-libs libsmbclient libwbclient samba-common sssd-krb5-common sssd-ipa sssd-nfs-idmap sssd-ldap sssd-client sssd-ad sssd-common sssd-krb5 sssd-common-pac

#* install ufw (optional)
dnf -y install ufw
systemctl disable firewalld --now
systemctl enable ufw --now
for i in $(ufw status | wc -l); do
  ufw --force delete 1
done
ufw default deny incoming
ufw default allow outgoing
ufw enable


source ./bin/scripts/harden.sh


#* add rpmfusion repos
dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf -y install fedora-workstation-repositories
fedora-third-party enable
fedora-third-party refresh
dnf -y groupupdate core

#* cleanup
dnf clean all
dnf -y autoremove
dnf -y distro-sync

#* install media codecs
dnf -y --skip-broken install @multimedia
dnf -y groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin --skip-broken
dnf -y groupupdate sound-and-video
dnf -y --allowerasing install ffmpeg
dnf -y install libwebp libwebp-devel
dnf -y install webp-pixbuf-loader

#* add flatpak
dnf -y install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak update -y --noninteractive

#* install snap
dnf -y install snapd
ln -s /var/lib/snapd/snap /snap
systemctl enable snapd --now
snap refresh #fix: not seeded yet will trigger and fix itself for the next command
snap install core
snap refresh core
snap refresh

#* cleanup
dnf clean all
dnf -y autoremove
dnf -y distro-sync

#* upgrade prefoemance
systemctl disable accounts-daemon.service
systemctl disable debug-shell.service

dnf -y --noautoremove remove dmraid device-mapper-multipath


#* install programing languages
dnf -y install python python3 python-pip python3-pip
dnf -y install gcc-c++ make gcc
dnf -y install java-1.8.0-openjdk java-11-openjdk java-latest-openjdk
dnf -y install git nodejs npm
dnf -y install golang pcre-devel

#* install docker
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
dnf -y install docker
systemctl enable docker --now


#* install common packages
dnf -y install nano neofetch btrfs-progs lvm2 xfsprogs ntfs-3g ntfsprogs exfatprogs udftools p7zip p7zip-plugins hplip hplip-gui inotify-tools guvcview selinux-policy-devel

#todo: auto copy files to os

systemctl enable fstrim.timer --now
systemctl enable systemd-oomd.service --now
systemctl enable sshd.socket --now

mvln /home /var/home
# mv -f /home /var/home
# ln -s /var/home /home

mvln /root /var/roothome
# mv -f /root /var/roothome
# ln -s /var/roothome /root

mvln /usr/share /var/usrshare
# mv -f /usr/share /var/usrshare
# ln -s /var/usrshare /usr/share

ln -s /etc/localtime /usr/share/zoneinfo/America/New_York
ln -s /etc/systemd/system/multi-user.target.wants/tuned.service /usr/lib/systemd/system/tuned.service
# ln -s /etc/systemd/system/kdump.service.target /dev/null

#todo: lookup editing kernel arguments

if [ "$1" = "-s" -o "$1" = "--server" -o "$1" = "-server" -o "$1" = "server" ]; then
  source ./bin/scripts/server/install.sh
elif [ "$1" = "-d" -o "$1" = "--desktop" -o "$1" = "-desktop" -o "$1" = "desktop" ]; then
  source ./bin/scripts/desktop/install.sh
fi
