# Installation

> :red_circle: **IMPORTANT**: **You should NOT deploy this flake directly on your machine :exclamation:
> It will not succeed.** This flake contains my hardware configurations.
> Which is not suitable for your hardware, and requires my private secrets.
> You may use this repo as a reference to build your own configuration.

---

For NixOS:

```bash
# clone my dotfiles repository
git clone https://github.com/oxodx/nix-config.git

# go to the dotfiles folder
cd nix-config

# deploy one of the configurations based on hostname
sudo nixos-rebuild switch --flake .#oxod-laptop
# or you could also use
nh os switch .#oxod-laptop
```
