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
# dnf -y install @base-x
dnf -y install gtk4-devel rust-gtk4-devel qt-devel
dnf -y install xorg-x11-server-common xorg-x11-server-devel xorg-x11-xauth xorg-x11-drivers xorg-x11-drv-nvidia x11docker libX11-common libX11-devel
dnf -y install xorg-x11-server-Xwayland xorg-x11-server-Xwayland-devel wayland-devel libwayland-server
dnf -y install xorg-x11-util-macros xorg-x11-xinit-session wayland-utils
dnf -y install xsettingsd xsensors xsecurelock xmodmap xfontsel xdpyinfo xcursorgen libXfont libXfont-devel libICE libICE-devel

#* install fonts
dnf -y install jetbrains-mono-fonts
