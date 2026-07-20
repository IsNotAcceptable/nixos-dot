# NixOS Dotfiles

A comprehensive repository of configuration files (dotfiles) for a NixOS system. Contains the complete system configuration, including package management, hardware settings, and user environment configuration via Home Manager.

## 📁 Repository Structure

```
nixos/
├── configuration.nix          # Main NixOS system configuration file
├── hardware-configuration.nix # Hardware configuration (auto-generated)
├── flake.nix                  # Flake configuration for reproducible builds
├── flake.lock                 # Lock file for Flake inputs versions
├── pkgs.nix                   # Package list and declarations
├── WM-DE.nix                  # Window manager/Desktop environment configuration
├── nvidia.nix                 # NVIDIA GPU configuration
├── servicesD.nix              # System services configuration
└── home/                      # Home Manager user configuration
    └── home.nix               # Main home-manager configuration file
```

## 🤔 What are Dotfiles for NixOS?

Dotfiles are configuration files for your operating system and applications (often starting with a dot in UNIX systems). In the context of NixOS, they are Nix language files that describe:

- **System configuration** — which packages are installed, which services are running
- **Hardware parameters** — disk partitions, graphics card, other hardware specs
- **User environment** — configured via Home Manager for per-user setup
- **Dependency versions** — managed through Flakes for full reproducibility

NixOS dotfiles are declarative: you describe the *desired state* of your system, and NixOS makes it so.

## 🚀 Getting Started

### Prerequisites

- **NixOS** installed (version 24.05 or newer)
- **Flakes** support enabled (usually enabled by default)

### Installation

1. Clone the repository to your system:

```bash
sudo git clone https://github.com/IsNotAcceptable/nixos-dot /etc/nixos/
cd /etc/nixos/
```

2. **Important**: The `home/` folder must stay in the root of the repository alongside all other files. Do not move it!

3. Customize the configuration for your system:
   - Edit `configuration.nix` — change hostname, users, and general settings
   - Update `hardware-configuration.nix` if needed for your hardware
   - Modify `WM-DE.nix` for your preferred window manager/desktop environment
   - Adjust `pkgs.nix` to match your software needs
   - Update `home/home.nix` for user-specific settings

4. Apply the configuration:

```bash
sudo nixos-rebuild switch --flake .#empty
```

## 📋 File Descriptions

### configuration.nix
The main system configuration file. Includes:
- Module imports for other configuration files
- Networking settings (hostname, DNS, NetworkManager)
- Bluetooth and driver configuration
- User accounts and group membership
- Security settings (doas instead of sudo)
- System state version for migrations

### hardware-configuration.nix
Auto-generated during NixOS installation. Contains:
- Bootloader configuration (GRUB)
- Filesystems and mount points
- Hardware detection and kernel modules

**⚠️ Do not edit manually — regenerate via `nixos-generate-config` if needed**

### flake.nix
Defines the Flake inputs and outputs for reproducible builds:
- **Inputs**: nixpkgs versions, home-manager, nixvim, and other dependencies
- **Outputs**: NixOS configuration for the `empty` host
- Multi-channel nixpkgs support (unstable, stable)

### pkgs.nix
System packages configuration. Lists:
- Core utilities and libraries
- Development tools and IDEs
- Multimedia applications
- Custom packages and overlays

### WM-DE.nix
Desktop environment and window manager configuration:
- Selection and configuration of WM/DE (Hyprland, i3, GNOME, etc.)
- Display server setup (Wayland/X11)
- Theme and appearance settings
- User interface utilities

### nvidia.nix
NVIDIA GPU-specific configuration:
- Driver installation and setup
- GPU output parameters
- CUDA toolkit (if needed)

### servicesD.nix
System services and daemons:
- Background service configuration
- System-wide processes
- Service auto-start settings

### home/ (Home Manager)
User-specific environment configuration:
- `home/home.nix` — main configuration file for user `vibeman`
- Dotfile management (copies/links user config files)
- Shell configuration (zsh, bash, fish)
- Per-application settings

## 🔧 Common Operations

### Update configuration
```bash
cd /etc/nixos
git pull
sudo nixos-rebuild switch --flake .#empty
```

### Clean up old generations
```bash
sudo nix-collect-garbage --delete-older-than 30d
```

### Dry run before applying changes
```bash
sudo nixos-rebuild dry-run --flake .#empty
```

### Rollback to previous generation
```bash
sudo nixos-rebuild switch --flake .#empty --rollback
```

### List all system generations
```bash
nix-env --list-generations -p /nix/var/nix/profiles/system
```

## 💾 System Specifications

- **CPU**: Intel Core i7-4790
- **RAM**: 32 GB
- **GPU**: NVIDIA GeForce GTX 1070 Ti
- **Storage**:
  - HDD 232.9 GB (system root, /home, swap)
  - SSD 894.3 GB (secondary storage)

## 📚 Useful Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nixpkgs Search](https://search.nixos.org/packages)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [NixOS Wiki](https://nixos.wiki/)
- [Nix Language Guide](https://nixos.org/manual/nix/stable/language/index.html)

## ⚠️ Important Notes

1. **Configuration files are in the repository root** — including the `home/` directory. Do not reorganize them into subdirectories!

2. **Replace `vibeman` username** — This username appears throughout the configuration. Update it to your username:
   ```bash
   grep -r "vibeman" --include="*.nix" | grep -v flake.lock
   ```

3. **State Version** — The `system.stateVersion` (24.05) ensures compatibility when migrating between NixOS versions. Do not change it without careful consideration.

4. **Flake.lock** — Commit this file to git! It locks all dependency versions and ensures reproducibility across machines.

5. **Rebuild frequency** — You only need to run `nixos-rebuild switch` when you make changes. Regular updates use `nix flake update`.

## 🛠 Customization Guide

### Adding a new package
Edit `pkgs.nix` and add to `environment.systemPackages`:
```nix
environment.systemPackages = with pkgs; [
  vim
  git
  # Add new packages here
];
```

### Changing the window manager
Edit `WM-DE.nix` and uncomment/select your preferred WM:
```nix
# Example: Enable Hyprland
wayland.windowManager.hyprland.enable = true;
```

### Adding user-specific applications
Edit `home/home.nix` and configure under `home.packages`:
```nix
home.packages = with pkgs; [
  firefox
  vscode
  # Add user packages here
];
```

## 📝 License

Feel free to use and modify this configuration for your own system. Consider adding an appropriate license file if you plan to share it publicly.

---

**Questions or issues?** Create an issue or a discussion in this repository! 🚀
