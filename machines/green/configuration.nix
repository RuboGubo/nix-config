{
  imports = [
    ./disko.nix
  ];
  networking.useNetworkd = true; # Need this to fix a very random bug.

  # UEFI bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  # NVIDIA Graphics Configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Modesetting is required for most wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module (for driver 515.43.04+)
    # Set to false for the proprietary version
    open = false;

    # Enable the Nvidia settings menu
    nvidiaSettings = true;

    # Select the appropriate driver version for your specific GPU
    # package = config.hardware.nvidia.package; # Use default package

    # Prime configuration for hybrid graphics
    prime = {
      # Make sure bus ID values are correct. Use lspci | grep VGA to find them
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";

      # Enable NVIDIA Optimus support (for laptops with hybrid graphics)
      # offload.enable = true;

      # For better performance, you can enable sync mode instead
      sync.enable = true;
    };
  };

  clan.core.settings.state-version.enable = true;
}
