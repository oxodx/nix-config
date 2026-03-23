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
}
