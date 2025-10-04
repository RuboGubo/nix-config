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

  home-manager.users."gss" = {
    home.stateVersion = "24.11";

    imports = [
      ../../modules/zsh.nix
    ];

    home.packages = with pkgs; [
      direnv
      eza
    ];

    # Deploy files
    home.file."Projects/green_siren_services" = {
      source = ./podman;
      force = true;
    };
  };
}
