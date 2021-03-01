# Scripts
Collection of my configs and scripts I use for my Fedora installation.

### setup
Script for starting off fresh Fedora installs with some tweaks and my software.

### dconf-backup
Making dconf backups and restoring them.

# Quick install
```bash
git clone https://github.com/patryk-kepa/fedora-setup
cd setup
sudo bash setup.sh
```

# Wine
```bash
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/33/winehq.repo
sudo dnf -y install winehq-stable
```
