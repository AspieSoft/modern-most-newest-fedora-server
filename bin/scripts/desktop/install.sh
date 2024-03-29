#!/bin/bash

#* upgrade prefoemance
dnf -y install tlp tlp-rdw thermald

systemctl enable thermald --now

systemctl enable tlp --now
tlp start

dnf -y copr enable elxreno/preload
dnf -y install preload
systemctl enable preload --now

systemctl disable NetworkManager-wait-online.service


#* install x11 base
dnf -y install @base-x
dnf -y install wayland-devel xorg-xwayland xorg-x11-server-Xwayland xorg-x11-server-Xwayland-devel xorg-x11-server-common xorg-x11-server-devel libwayland-server xorg-x11-xauth xorg-x11-drivers xorg-x11-drv-nvidia x11docker libX11-common libX11-devel gtk4-devel rust-gtk4-devel qt-devel
