# Services Configuration
# Tailscale and other system services

{ config, lib, pkgs, ... }:

{
  imports = [
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  services.vscode-server.enable = true;
  services.vscode-server.enableFHS = true;

  environment.systemPackages = with pkgs; [
    tailscale
  ];


  # Enable Tailscale
  services.tailscale = {
    enable = true;
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

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    channel = "https://nixos.org/channels/nixos-24.05";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ];
  };
}
