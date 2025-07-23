# NixOS Server Configuration

A modular NixOS configuration for a home server with ZFS storage, security hardening, development tools, and essential applications.

## 🚀 Features

### Storage & Filesystem
- **ZFS Support**: Automatic import, mounting, and monthly scrubbing of the `tank` pool
- **ZFS Snapshots**: Automated snapshot management with configurable retention

### Security
- **UFW Firewall**: Configured to allow SSH (port 22) and HTTPS (port 443) from CGNAT range (100.64.0.0/10)
- **SSH Hardening**: Disabled password authentication and root login, SSH key authentication only
- **Fail2ban**: Protection against brute force attacks

### Services
- **Tailscale**: VPN service for secure remote access
- **System Maintenance**: Automatic updates, garbage collection, and Nix store optimization

### Development Environment
- **Python**: Full Python 3 environment with pip, virtualenv, and common packages (numpy, pandas, jupyter, etc.)
- **Rust/Cargo**: Complete Rust toolchain with rustfmt, rust-analyzer, and clippy
- **Neovim**: Configured with essential plugins for development
- **VSCode**: Microsoft Visual Studio Code editor

### Applications
- **Firefox**: Web browser with privacy and security optimizations
- **Signal Desktop**: Secure messaging application
- **1Password**: Password manager with GUI and CLI tools

### Containerization
- **Docker**: Container runtime with Docker Compose
- **Container Management**: Additional tools like dive, ctop, and lazydocker
- **Automated Cleanup**: Weekly cleanup of unused Docker resources

### Shell Environment
- **Zsh**: Default shell with Oh-my-zsh configuration
- **Starship Prompt**: Modern, fast shell prompt
- **Rich Aliases**: Comprehensive set of aliases for system management, Git, Docker, NixOS, and ZFS

## 📁 Project Structure

```
nix-server/
├── configuration.nix          # Main NixOS configuration (imports all modules)
├── hardware-configuration.nix # Hardware-specific settings (placeholder)
├── modules/
│   ├── zfs.nix               # ZFS configuration with tank pool management
│   ├── security.nix          # UFW firewall and SSH daemon setup
│   ├── services.nix          # Tailscale and system services
│   ├── development.nix       # Programming tools and development environment
│   ├── applications.nix      # User applications (Firefox, Signal, 1Password)
│   ├── docker.nix           # Docker and container management
│   └── shell.nix            # Zsh and Oh-my-zsh configuration
└── README.md                # This file
```

## 🔧 Installation & Setup

### Prerequisites
- A running NixOS system
- Root access for system configuration

### Step 1: Clone the Repository
```bash
git clone https://github.com/santiago-mooser/nix-server.git
cd nix-server
```

### Step 2: Update Hardware Configuration
Replace the placeholder `hardware-configuration.nix` with your actual hardware configuration:

```bash
# Generate your hardware configuration
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

### Step 3: Configure SSH Keys
Edit `modules/security.nix` and add your SSH public keys:

```nix
users.users.santiago.openssh.authorizedKeys.keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD... your-key@hostname"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... another-key@hostname"
];
```

### Step 4: Apply the Configuration
```bash
# Test the configuration first
sudo nixos-rebuild test

# If everything works correctly, apply permanently
sudo nixos-rebuild switch
```

### Step 5: Setup Tailscale
After the system rebuilds, set up Tailscale:

```bash
sudo tailscale up
```

## ⚙️ Customization

### Adding SSH Keys
Edit `modules/security.nix` and add your public keys to the `authorizedKeys.keys` array.

### Modifying ZFS Configuration
Edit `modules/zfs.nix` to:
- Change the pool name from `tank` to your pool name
- Adjust scrubbing schedule
- Modify snapshot settings

### Customizing Firewall Rules
Edit `modules/security.nix` to modify UFW rules or change the CGNAT range.

### Adding Development Tools
Edit `modules/development.nix` to add additional programming languages or tools.

## 🔍 Useful Commands

### System Management
```bash
# Rebuild and switch configuration
sudo nixos-rebuild switch

# Test configuration without making it default
sudo nixos-rebuild test

# Rebuild for next boot only
sudo nixos-rebuild boot
```

### ZFS Management
```bash
# List pools
zpool list

# Check pool status
zpool status tank

# List ZFS filesystems
zfs list

# Manual scrub
zpool scrub tank
```

### Docker Management
```bash
# Container status
docker ps

# Clean up resources
docker system prune -af --volumes

# Monitor containers
ctop
```

### Tailscale Management
```bash
# Check status
tailscale status

# Connect
tailscale up

# Disconnect
tailscale down
```

## 🛡️ Security Notes

- SSH password authentication is disabled by default
- Root SSH login is disabled
- UFW firewall restricts access to SSH and HTTPS from CGNAT range only
- Fail2ban provides additional protection against brute force attacks
- Regular system updates are enabled (without automatic reboots)

## 📝 Maintenance

The configuration includes automated maintenance:
- **Weekly Docker cleanup**: Removes unused containers, images, and volumes
- **Weekly Nix garbage collection**: Removes old system generations
- **Daily Nix store optimization**: Deduplicates files in the Nix store
- **Monthly ZFS scrubbing**: Verifies data integrity on the tank pool

## 🤝 Contributing

Feel free to submit issues and pull requests to improve this configuration.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
