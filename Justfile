update-gss:
    nix flake update && git add flake.lock && git commit -m "update" && clan machines update node1 --build-host localhost

build-iso:
    nixos-rebuild build-image --image-variant iso --flake .#installer