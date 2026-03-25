Here's your README with the structure preserved, just simplified to use your single `romantic` key:

````markdown
# Secrets Management

All my secrets are safely encrypted via agenix, and stored in a separate private GitHub repository
and referenced as a flake input in this flake.

The encryption is done using my personal SSH key (`romantic`), which is distributed to all my hosts.
The key is protected by full disk encryption and my physical USB key, ensuring secrets remain secure
at rest and in transit.

In this way, all secrets are still encrypted when transmitted over the network and written to
`/nix/store`. They are decrypted only when they are finally used.

In addition, we further improve the security of secret files by storing them in a separate private
repository.

This directory contains this `README.md`, and a `nixos.nix`/`darwin.nix` file that is used to
decrypt all my secrets via `agenix`. Then, I can use them in this flake.

## Adding or Updating Secrets

> All the operations in this section should be performed in my private repository: `nix-secrets`.

This task is accomplished using the [agenix](https://github.com/ryantm/agenix) CLI tool with the
`./secrets.nix` file, so you need to have it installed first:

To use agenix temporarily, run:

```bash
nix shell github:ryantm/agenix#agenix
```
````

or agenix provided by ragenix, run:

```bash
nix shell github:yaxitech/ragenix#ragenix
```

Suppose you want to add a new secret file `xxx.age`. Follow these steps:

1. Navigate to your private `nix-secrets` repository.
2. Edit `secrets.nix` and add a new entry for `xxx.age`, defining the encryption keys and the secret
   file path, for example:

```nix
# This file is not imported into your NixOS configuration. It is only used for the agenix CLI.
# agenix use the public keys defined in this file to encrypt the secrets.
# and users can decrypt the secrets by any of the corresponding private keys.

let
  # My personal SSH key - used for all secrets
  romantic = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFq1eYW8+3zOgM1/8JofUiAlimyEBjSVLerE46pYQBTK oxod@romantic";
in {
  "./xxx.age".publicKeys = [ romantic ];
}
```

3. Create and edit the secret file `xxx.age` interactively using the following command:

```shell
agenix -e ./xxx.age -i ~/.ssh/romantic
```

Alternatively, you can encrypt an existing file to `xxx.age` using the following command:

```shell
cat xxx | agenix -e ./xxx.age -i ~/.ssh/romantic
```

`agenix` will encrypt the file with all the public keys we defined in `secrets.nix`, so all the
users and systems defined in `secrets.nix` can decrypt it with their private keys.

## Deploying Secrets

> All the operations in this section should be performed in this repository.

First, add your own private `nix-secrets` repository and `agenix` as a flake input, and pass them to
sub modules via `specialArgs`:

```nix
{
  inputs = {
    # ......

    # secrets management, lock with git commit at v0.15.0
    agenix.url = "github:ryantm/agenix/564595d0ad4be7277e07fa63b5a991b3c645655d";

    # my private secrets, it's a private repository, you need to replace it with your own.
    mysecrets = { url = "github:0x0Dx/nix-secrets"; flake = false; };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations = {
      nixos-test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # Set all input parameters as specialArgs of all sub-modules
        # so that we can use the `agenix` & `mysecrets` in sub-modules
        specialArgs = inputs;
        modules = [
          # ......

          # import & decrypt secrets in `mysecrets` in this module
          ./secrets/default.nix
        ];
      };
    };
  };
}
```

Then, create `./secrets/default.nix` with the following content:

```nix
# import & decrypt secrets in `mysecrets` in this module
{ config, pkgs, agenix, mysecrets, ... }:

{
  imports = [
     agenix.nixosModules.default
  ];

  # if you changed this key, you need to regenerate all encrypt files from the decrypt contents!
  age.identityPaths = [
    # using my personal SSH key for decryption
    "/home/oxod/.ssh/romantic"
  ];

  age.secrets."xxx" = {
    # whether secrets are symlinked to age.secrets.<name>.path
    symlink = true;
    # target path for decrypted file
    path = "/etc/xxx/";
    # encrypted file path
    file =  "${mysecrets}/xxx.age";  # refer to ./xxx.age located in `mysecrets` repo
    mode = "0400";
    owner = "root";
    group = "root";
  };
}
```

From now on, every time you run `nixos-rebuild switch`, it will decrypt the secrets using the
private keys defined in `age.identityPaths`. It will then symlink the secrets to the path defined by
the `age.secrets.<name>.path` argument, which defaults to `/etc/secrets`.

## Adding a new host

1. Copy your `romantic` SSH key to the new host:

   ```bash
   scp ~/.ssh/romantic* user@new-host:~/.ssh/
   ssh user@new-host "chmod 600 ~/.ssh/romantic"
   ```

2. On the new host, clone this repo and run `nixos-rebuild switch` to deploy it, all the secrets
   will be decrypted automatically via the SSH private key.

## Troubleshooting

### 1. NixOS Module

Check logs:

```
journalctl | grep -5 agenix
```

## Other Replacements

- [ragenix](https://github.com/yaxitech/ragenix): A Rust reimplementation of agenix.
  - agenix is mainly written in bash, and it's error message is quite obscure, a little typo may
    cause some errors no one can understand.
  - with a type-safe language like Rust, we can get a better error message and less bugs.
