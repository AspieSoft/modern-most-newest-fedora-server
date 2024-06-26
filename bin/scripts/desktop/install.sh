#!/bin/bash

#* install x11 base
dnf -y install @base-x
dnf -y install gtk4-devel rust-gtk4-devel qt-devel
dnf -y install xorg-x11-server-Xorg xorg-x11-server-common xorg-x11-server-devel xorg-x11-xauth xorg-x11-drivers xorg-x11-drv-nvidia x11docker libX11-common libX11-devel libX11-xcb libxcb-devel
dnf -y install xorg-x11-server-Xwayland xorg-x11-server-Xwayland-devel wayland-devel libwayland-server
dnf -y install xorg-x11-util-macros xorg-x11-xinit-session wayland-utils
dnf -y install xsettingsd xsensors xsecurelock xmodmap xfontsel xdpyinfo xcursorgen libXfont libXfont-devel libICE libICE-devel

dnf -y install lxappearance plymouth-system-theme mesa-dri-drivers mesa-vulkan-drivers abattis-cantarell-fonts xorg-x11-drv-fbdev xorg-x11-drv-vesa

#todo: auto detect gpu type
# dnf -y install xorg-x11-amdgpu

# dnf -y --skip-broken install xorg-x11-*
dnf -y install xorg-x11-xdm
echo "DISPLAYMANAGER=xdm" >> /etc/sysconfig/desktop

#* install fonts
dnf -y install jetbrains-mono-fonts


#* upgrade prefoemance
dnf -y install tlp tlp-rdw thermald

systemctl enable thermald --now

systemctl enable tlp --now
tlp start

dnf -y copr enable elxreno/preload
dnf -y install preload
systemctl enable preload --now

systemctl disable NetworkManager-wait-online.service
