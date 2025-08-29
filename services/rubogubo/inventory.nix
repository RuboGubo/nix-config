{
  rubogubo-password = {
    module = {
      name = "users";
      input = "clan-core";
    };

    roles.default.settings = {
      user = "rubogubo";
      share = true;
    };

    # Role to tag matching is done in clan.nix
  };
}
