# My Clan Based Config

machines: Machines Config

modules: Reusable machine Config 
  ^ Import into machine config

services: Reusabel inventory services
  ^ Use in inverntory

## Yonsei VPN

The `rubogubo` desktop profile includes `yonsei-vpn`, built from the pinned
[independent SecuwaySSL-compatible client](https://github.com/mrcha033/secuway-vpn).
It uses native Linux OpenVPN with an LEA provider; the Windows installer is not
needed.

The NixOS desktop configuration also installs NetworkManager's OpenVPN plugin
with LEA support, so GNOME Settings can manage the connection.

### Set up GNOME Settings

Rebuild your desktop configuration first (use `green` on that machine):

```sh
sudo nixos-rebuild switch --flake .#green-laptop
```

Then enroll once from this repository, entering your Yonsei portal ID,
password, and app OTP in the terminal:

```sh
nix run .#yonsei-vpn -- login --output "$HOME/.config/yonsei-vpn/Yonsei.ovpn"
```

Open **Settings → Network → VPN → + → Import from file**, and select
`~/.config/yonsei-vpn/Yonsei.ovpn`. After importing, use the VPN switch in
GNOME Settings or Quick Settings to connect and disconnect. If Yonsei expires
or revokes the certificate, enroll again and replace the imported connection.
The first authenticated connection still needs to be verified with your account.

### Terminal connection

You can also check the runtime and gateway, then connect directly:

```sh
nix run .#yonsei-vpn -- doctor
nix run .#yonsei-vpn -- probe
nix run .#yonsei-vpn -- connect
```

OpenVPN requests sudo for a terminal connection. Keep the command running and
press Ctrl+C to disconnect. Once the desktop configuration is rebuilt, the same commands
are available directly as `yonsei-vpn doctor`, `yonsei-vpn probe`, and
`yonsei-vpn connect`.

The client caches the server-issued profile in a mode-0600 file under
`${XDG_CONFIG_HOME:-~/.config}/mrcha-skills/secuway/profiles`. Passwords and OTPs
are not cached. `yonsei-vpn status` reports the local profile cache, and
`yonsei-vpn forget` removes it; use `yonsei-vpn login` to renew an expired
profile. Keep exported profiles and credentials outside this repository.
