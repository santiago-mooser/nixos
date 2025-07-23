# Services Configuration
# Tailscale and other system services

{ config, lib, pkgs, ... }:

{
  # Enable vscode-server for remote development
  imports = [
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];
  services.vscode-server.enable = true;

  # Install VSCode with FHS environment and dependencies for extensions
  environment.systemPackages = with pkgs; [
    tailscale
    (vscode.fhsWithPackages (ps: with ps; [
      nodejs
      python3
      python3Packages.pip
      python3Packages.isort
      python3Packages.black
      git
    ]))
  ];

  # Enable Tailscale
  services.tailscale = {
    enable = true;
    # Allow Tailscale to modify routing tables
    useRoutingFeatures = "both";
  };

  # Enable systemd-resolved for better DNS handling with Tailscale
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
    extraConfig = ''
      DNS=1.1.1.1 8.8.8.8
      FallbackDNS=1.0.0.1 8.8.4.4
    '';
  };

  # Allow Tailscale through the firewall (this will be handled by UFW, but keeping for compatibility)
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # Enable avahi for local network discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable automatic updates for security (optional but recommended)
  system.autoUpgrade = {
    enable = true;
    allowReboot = false; # Set to true if you want automatic reboots
    channel = "https://nixos.org/channels/nixos-24.05";
  };

  # Enable automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Optimize Nix store automatically
  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ];
  };
}
