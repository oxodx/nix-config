# Disko Config

Generate LUKS passphrase to encrypt the root partition, it's used by disko.

```bash
# Generate a token for k3s
K3S_TOKEN_FILE=./kubevirt-k3s-token
K3S_TOKEN=$(grep -ao '[A-Za-z0-9]' < /dev/random | head -64 | tr -d '\n' ; echo "")
echo $K3S_TOKEN > $K3S_TOKEN_FILE
```

### Partition the HDD & install NixOS via disko

```bash
# enter an shell with git/vim/ssh-agent/gnumake available
nix-shell -p git vim gnumake
# clone this repository
git clone https://github.com/0x0Dx/nix-config.git

cd nix-config

# one line
sudo nix run --experimental-features "nix-command flakes" 'github:nix-community/disko#disko-install' -- \
  --write-efi-boot-entries --disk main /dev/sda --flake .#kubevirt-homelab


# or step by step
## 1. partition & format the disk via disko
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko hosts/k8s/disko-config/kubevirt-disko-fs.nix
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
```
