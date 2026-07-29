update-gss:
    git checkout main && nix flake update && git add flake.lock && git commit -m "update" && clan machines update node1 green-laptop --build-host localhost && git push

build-iso:
    nixos-rebuild build-image --image-variant iso --flake .#installer