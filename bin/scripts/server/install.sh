#!/bin/bash

#* install x11 base
dnf -y install @base-x
dnf -y install wayland-devel xorg-x11-server-Xwayland xorg-x11-server-Xwayland-devel xorg-x11-server-common xorg-x11-server-devel libwayland-server xorg-x11-xauth xorg-x11-drivers xorg-x11-drv-nvidia x11docker libX11-common libX11-devel gtk4-devel rust-gtk4-devel qt-devel


#* install ly
git clone --recurse-submodules https://github.com/fairyglade/ly
cd ly
make
make install installsystemd
systemctl enable ly.service --now
systemctl disable getty@tty2.service
cd ..
rm -rf ./ly

#* install i3
dnf -y install i3 i3status dmenu i3lock xbacklight feh conky

systemctl set-default graphical.target
