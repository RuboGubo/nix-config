{ pkgs, ... }:
{
  users.users.gss = {
    description = "Green Siren Services User";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "podman"
    ];
    shell = pkgs.zsh;
  };
  
  
}
