# Disko Config

## Partition the SSD & install NixOS via disko

```bash
# enter a shell with git/vim/ssh-agent/gnumake available
nix-shell -p git vim gnumake
# clone this repository
git clone https://github.com/0x0Dx/nix-config.git
cd nix-config

## 1. partition & format the disk via disko
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode destroy,format,mount hosts/k8s/disko-config/kubevirt-disko-fs.nix

## 2. install nixos
sudo nixos-install --root /mnt --no-root-password --show-trace --verbose --flake .#kubevirt-homelab

# enter into the installed system, check password & users
# `su oxod` => `sudo -i` => enter oxod's password => successfully login
# if login failed, check the password you set in install-1, and try again
nixos-enter

# NOTE: DO NOT skip this step!!!
# copy the essential files into /persistent
# otherwise the / will be cleared and data will lost
## NOTE: preservation just create links from / to /persistent
##       We need to copy files into /persistent manually!!!
mv /etc/machine-id /persistent/etc/
mv /etc/ssh /persistent/etc/
mkdir -p /persistent/home/oxod
chown -R oxod:oxod /persistent/home/oxod

# add your k3s token at /persistent/kubevirt-k3s-token
# If you dont have it generated yet you can run
echo "$(openssl rand -hex 32)" > /persistent/kubevirt-k3s-token
chmod 600 /persistent/kubevirt-k3s-token
```
