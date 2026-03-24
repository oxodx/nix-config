# Variables

Common variables and configuration used in my NixOS configurations.

## Current Structure

```
vars/
├── README.md
└── default.nix         # Main variables entry point
```

## Components

### 1. `default.nix`

Contains user information, SSH keys, and password configuration:

- User credentials (username, full name, email)
- Initial hashed password for new installations
- SSH authorized keys (main and backup sets)
- Public key references for system access

## Usage

These variables are imported and used throughout the configuration to ensure consistency across all
hosts and maintain centralized network and security settings.
