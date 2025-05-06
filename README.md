# NixOS Flake Configuration

This repository contains a flake-based, multi-host NixOS configuration for managing two machines:

- `nixos-server`: a desktop system with GUI, development tools, and user-specific setup
- `nixos-router`: a minimal router/server system with essential networking and firewall configuration

## Usage

### Build and switch configuration on the host machine:

For `nixos-server`:
```sh
sudo nixos-rebuild switch --flake .#nixos-server
```
For `nixos-router`:
```sh
sudo nixos-rebuild switch --flake .#nixos-router
```

### Update flake inputs
```sh
nix flake update
```

### Add a new host
1. Create `hosts/new-host/configuration.nix`

2. Add its hardware config: `hardware-configuration.nix`

3. Add a new entry under `nixosConfigurations` in `flake.nix`
 
## Typical Flow After a Fresh Headless Install

```bash
# Temporarily install Git
nix-shell -p git

# Clone your configuration repository
git clone https://github.com/hanapedia/nixos-config.git
cd nixos-config

# Rebuild the system using your flake config
sudo nixos-rebuild switch --flake .#nixos-router

# Authenticate to Tailscale using a QR code
nix-shell -p qrencode
./scripts/tailscale-up-qr.sh
```

## Notes
`hardware-configuration.nix` is host-specific and generated using `nixos-generate-config`.

Each host can import only the modules it needs.

GUI apps (e.g., ghostty, google-chrome) are isolated in `gui-apps.nix` and only imported by `nixos-server`.
