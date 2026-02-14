update-gss:
    nix flake update personal-website primes && clan machines update node1

build-iso:
    nixos-rebuild build-image --image-variant iso --flake .#installer