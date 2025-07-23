# Security Configuration
# NixOS native firewall and SSH daemon configuration

{ config, lib, pkgs, ... }:

{
  # Enable NixOS native firewall
  networking.firewall = {
    enable = true;

    # Default deny all incoming connections
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];

    # Custom firewall rules using iptables
    extraCommands = ''
      # Allow SSH (port 22) from CGNAT range only
      iptables -A nixos-fw -p tcp --dport 22 -s 100.64.0.0/10 -j ACCEPT

      # Allow HTTPS (port 443) from CGNAT range only
      iptables -A nixos-fw -p tcp --dport 443 -s 100.64.0.0/10 -j ACCEPT

      # Allow loopback
      iptables -A nixos-fw -i lo -j ACCEPT

      # Allow established and related connections
      iptables -A nixos-fw -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    '';

    # Clean up rules when firewall is stopped
    extraStopCommands = ''
      iptables -D nixos-fw -p tcp --dport 22 -s 100.64.0.0/10 -j ACCEPT 2>/dev/null || true
      iptables -D nixos-fw -p tcp --dport 443 -s 100.64.0.0/10 -j ACCEPT 2>/dev/null || true
      iptables -D nixos-fw -i lo -j ACCEPT 2>/dev/null || true
      iptables -D nixos-fw -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT 2>/dev/null || true
    '';
  };

  # SSH daemon configuration
  services.openssh = {
    enable = true;
    settings = {
      # Disable password authentication
      PasswordAuthentication = false;

      # Disable root login
      PermitRootLogin = "no";

      # Enable public key authentication
      PubkeyAuthentication = true;

      # Other security settings
      PermitEmptyPasswords = false;
      ChallengeResponseAuthentication = false;
      X11Forwarding = false;

      # Use protocol 2 only
      Protocol = 2;

      # Limit authentication attempts
      MaxAuthTries = 3;

      # Set login grace time
      LoginGraceTime = 60;
    };

    # Allow specific users (add more as needed)
    allowSFTP = true;
  };

  # Configure SSH keys for the santiago user
  users.users.santiago.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICpHtBPtPyDO/KSpuHmhAI6i2h5hVVZIQ/S1Qk5uOqiX santiago"
  ];

  # Fail2ban for additional SSH protection (optional but recommended)
  services.fail2ban = {
    enable = true;
    jails = {
      sshd = {
        settings = {
          enabled = true;
          port = "ssh";
          filter = "sshd";
          logpath = "/var/log/auth.log";
          maxretry = 10;
          bantime = 3600;
          findtime = 600;
        };
      };
    };
  };
}
