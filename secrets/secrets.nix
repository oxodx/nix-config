let
  oxod = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIiHvSs6E8ECEY5Izj5/ZOpKKKVO2WQXN83D/QMzCRa";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIo1s8UrKSfAzjfwjeD5/qMcKsUi3d/6v7TR9/Q+5Q00";
  tv = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMcTsm7YWyCQgsxP5yQ0vH7IwjR5dtiKpw4BHPN5jysF";
in {
  "git.age".publicKeys = [oxod laptop tv];
  "camelot.age".publicKeys = [oxod laptop];
  "excalibur.age".publicKeys = [oxod laptop];
  "gawain.age".publicKeys = [oxod laptop];
  "magister-android-keystore.age".publicKeys = [oxod laptop];
  "magister-github-actions.age".publicKeys = [oxod laptop];
}
