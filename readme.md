# Empoleos

## Notice: this script is still in beta. Use at your own risk.

## Installation

First you will need to install [Fedora Server](https://fedoraproject.org/server/download/) or another fedora cli based on dnf.
Fedora Server is used for both the Desktop GUI and Server CLI.

After booting into the server cli, run one of the following scripts.

### For Desktop GUI

```shell
sudo dnf -y install git
git clone https://github.com/AspieSoft/Empoleos.git
Empoleos/install.sh --desktop
```

### For Server (i3 GUI)

```shell
sudo dnf -y install git
git clone https://github.com/AspieSoft/Empoleos.git
Empoleos/install.sh --server
```

### For Server (minimal CLI)

```shell
sudo dnf -y install git
git clone https://github.com/AspieSoft/Empoleos.git
Empoleos/install.sh
```
