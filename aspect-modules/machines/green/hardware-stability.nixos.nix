{ lib, config, ... }:
{
  # Target known issues on Green's older Intel + NVIDIA hybrid hardware:
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

  # Keep Green's Realtek USB Bluetooth adapter from aggressive USB power
  # saving. It is detected as 0bda:b00b (btusb).
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

  # Use deep sleep by default where available; it is generally more reliable
  # than s2idle on this generation of hardware.
  boot.kernelParams = [ "mem_sleep_default=deep" ];
}
