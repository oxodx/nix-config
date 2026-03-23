{ myvars, ... }:
{
  home = {
    inherit (myvars) username;
    stateVersion = "25.11";
  };
}
