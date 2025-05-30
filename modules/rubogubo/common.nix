{ config, clan-core, ... }:
{
  imports = [
    clan-core.clanModules.user-password
  ];
  # generate a random password for our user below
  # can be read using `clan secrets get <machine-name>-user-password` command
  clan.user-password.user = "rubogubo";
  users.users.rubogubo = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
    ];
    uid = 1000;
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
  };
}
