{
  home-manager.users."gss" = {
    home.stateVersion = "24.11";
    
    home.file."~/Projects/green_siren_services" = {
      source = ./podman;
      force = true;
    };
  };
}