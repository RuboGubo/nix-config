{ pkgs, osConfig, ... }:
{
  home.file."services/gss/docker-compose.yaml".text =
    osConfig.virtualisation.arion.projects.gss.settings.out.dockerComposeYamlText;

  home.packages = [ pkgs.podman-compose ];
}
