{ lib }:
{
  username = "oxod";
  userfullname = "0x0D";
  useremail = "0xOD@proton.me";
  # Generated using: mkpasswd -m yescrypt --rounds=11
  # Password: long, strong random string (full charset)
  # Rotation policy: changed annually
  # Purpose: system login password only
  # https://man.archlinux.org/man/crypt.5.en
  initialHashedPassword = "$y$jFT$O6/xS4HtgDk15dQB483T11$HU1zvzxucp/C.YiLM8brR68w39Qm.HwdVc5BXpOfO1B";
  # Public Keys that can be used to login to all my PCs, and servers.
  #
  # Since its authority is so large, we must strengthen its security:
  # 1. The corresponding private key must be:
  #    1. Generated locally on every trusted client via:
  #      ```bash
  #      # KDF: bcrypt with 256 rounds, takes 2s on Apple M2):
  #      # Passphrase: digits + letters + symbols, 12+ chars
  #      ssh-keygen -t ed25519 -a 256 -C "oxod@xxx" -f ~/.ssh/xxx
  #      ```
  #    2. Never leave the device and never sent over the network.
  # 2. Or just use hardware security keys like Yubikey/CanoKey.
  mainSshAuthorizedKeys = [
    # The main ssh keys for daily usage
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEJlh+mABI11oMlheEduOiPnTc8wgSs2/cHqhb9QW+Q oxod@kumquat"
  ];
  secondaryAuthorizedKeys = [
    # the backup ssh keys for disaster recovery
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFq1eYW8+3zOgM1/8JofUiAlimyEBjSVLerE46pYQBTK oxod@romantic"
  ];
}
