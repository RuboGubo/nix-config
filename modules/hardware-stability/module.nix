{
  flake.modules.nixos.hardware-stability =
    { lib, config, ... }:
    {
      # Target known issues on older Intel + NVIDIA hybrid desktops/laptops:
      # - flaky suspend/resume
      # - Realtek USB Bluetooth adapter resets and slow reconnect

      # BlueZ / Bluetooth baseline
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      hardware.bluetooth.settings = {
        General = {
          AutoEnable = true;
          FastConnectable = true;
          JustWorksRepairing = "always";
          Privacy = "device";
        };
      };

      # Keep the Realtek USB BT adapter from aggressive USB power saving.
      # Detected on green as: 0bda:b00b (btusb)
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="b00b", TEST=="power/control", ATTR{power/control}="on"
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="b00b", TEST=="power/autosuspend_delay_ms", ATTR{power/autosuspend_delay_ms}="-1"
      '';

      boot.extraModprobeConfig = ''
        options btusb enable_autosuspend=n
      '';

      # If NVIDIA PRIME offload is in use, prefer NVIDIA suspend helpers.
      hardware.nvidia.powerManagement.enable = lib.mkIf (
        config ? hardware
        && config.hardware ? nvidia
        && config.hardware.nvidia ? prime
        && config.hardware.nvidia.prime ? offload
        && config.hardware.nvidia.prime.offload.enable
      ) (lib.mkDefault true);

      # Use deep sleep by default where available (often better than s2idle
      # on this generation of hardware for battery/peripheral stability).
      boot.kernelParams = [ "mem_sleep_default=deep" ];
    };
}
