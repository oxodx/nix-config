# Hosts

This directory contains all host-specific configurations for my NixOS systems.

## Current Host Inventory

### Physical Machines

#### Laptops

Named after fruits:

| Host | Platform | Hardware | Purpose | Status | | `kumquat` | NixOS | ASUS TUF Gaming A15 FA506NCR
| Gaming & Daily Use | ✅ Active |

#### Servers

Named after characters from "Frieren: Beyond Journey's End":

| Host      | Platform | Hardware | Purpose            | Status    |
| --------- | -------- | -------- | ------------------ | --------- |
| `frieren` | NixOS    | i5-4570  | Homelab production | ✅ Active |

## Naming Conventions

- **laptops**: Random fruits
- **servers**: Characters from "Frieren: Beyond Journey's End" anime/manga

## How to Add a New Host

The easiest way to add a new host is to copy and adapt an existing similar configuration. All host
configurations follow similar patterns but are customized for specific hardware and use cases.

### General Process

1. **Identify a similar existing host** from the directory structure above
2. **Copy the entire directory** and rename it for your new host
3. **Adapt the configuration files** for your specific hardware and requirements
4. **Update references** in the flake outputs and networking configuration

### Essential Steps

1. Under `hosts/`
   1. Create a new folder under `hosts/` with the name of the new host.
   2. Create & add the new host's `hardware-configuration.nix` to the new folder, and add the new
      host's `configuration.nix` to `hosts/<name>/default.nix`.
   3. If the new host need to use home-manager, add its custom config into
      `home/hosts/linux/<name>.nix` or `home/hosts/darwin/<name>.nix`.
1. Under `outputs/`
   1. Add a new nix file named `outputs/<system-architecture>/src/<name>.nix`.
   2. Copy the content from one of the existing similar host, and modify it to fit the new host.
      1. Usually, you only need to modify the `name` and `tags` fields.
   3. [Optional] Add a new unit test file under `outputs/<system-architecture>/tests/<name>.nix` to
      test the new host's nix file.
   4. [Optional] Add a new integration test file under
      `outputs/<system-architecture>/integration-tests/<name>.nix` to test whether the new host's
      nix config can be built and deployed correctly.
1. Under `vars/networking.nix`
   1. Add the new host's static IP address.
   1. Skip this step if the new host is not in the local network or is a mobile device.

### File Templates

Use existing hosts as templates. The key files typically include:

- `default.nix` - Main host configuration
- `hardware-configuration.nix` - Auto-generated hardware settings
- Platform-specific files (e.g., `nvidia.nix`, etc.)

### Examples to Reference

- **Desktop systems**: See `kumquat/` for gaming/workstation setup
- **Server systems**: See `frieren/` for server setup

## References

[List of Fruits](https://en.wikipedia.org/wiki/List_of_culinary_fruits)
[List of Frieren characters](https://en.wikipedia.org/wiki/List_of_Frieren_characters)
