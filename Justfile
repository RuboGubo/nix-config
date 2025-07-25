build:
  compose2nix -inputs ./services/node1/podman-compose.yaml -output ./services/node1/podman-compose.nix -build -auto_start=false

deploy MACHINE: build
  clan machines update {{MACHINE}}

compose-up SERVICE:
  sudo systemctl start podman-compose-{{SERVICE}}-root.target

compose-down SERVICE:
  sudo systemctl stop podman-compose-{{SERVICE}}-root.target

compose-tui SERVICE:
  sudo systemctl-tui -l "*{{SERVICE}}*"

nextcloud OPTION="":
  sudo podman exec node1-nextcloud php occ {{OPTION}}

# compose COMMAND SERVICE:
# sudo systemctl {{COMMAND}} "*-{{SERVICE}}-*"
