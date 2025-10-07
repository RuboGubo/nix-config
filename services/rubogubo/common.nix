{
  pkgs,
  lib,
  ...
}:
{
  users.users.rubogubo = {
    description = "RuboGubo";
    isNormalUser = lib.mkForce true;
    isSystemUser = lib.mkForce false;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "podman"
    ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  # Should be it's own service at some point
  nix.settings.substituters = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];
  nix.settings.trusted-users = [ "rubogubo" ];

  programs.zsh.enable = true;

  home-manager.backupFileExtension = "bak";
  home-manager.users."rubogubo" = {
    imports = [
      ../../modules/zsh.nix
    ];
    home.stateVersion = "24.11";

    home.file."Projects/.keep".text = "";

    home.packages = with pkgs; [
      inotify-tools
      hollywood
      age
      ssh-to-age
      sops
      gnupg
      nix-output-monitor
      pkg-config
      jq
      yq
      home-manager

      # Command Line
      eza
      git
      zip
      bat
      just
      fastfetch
      cowsay

      # dev tools
      devenv

      # Rust tools
      wasm-pack

      # Server Admin
      systemctl-tui
    ];

    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "RuboGubo";
      userEmail = "ruben.john.ward@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        push.rebase = false;
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
  };
}
