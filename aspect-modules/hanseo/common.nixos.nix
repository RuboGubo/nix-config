{
  aspects,
  lib,
  pkgs,
  ...
}:
{
  imports = [ aspects.hanseo.ssh.nixos ];

  users.users.hanseo = {
    description = "Hanseo";
    isNormalUser = lib.mkForce true;
    isSystemUser = lib.mkForce false;
    uid = 1001;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
    ];
  };

  programs.zsh.enable = true;

  home-manager.users.hanseo = {
    home = {
      username = "hanseo";
      stateVersion = "25.11";
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
