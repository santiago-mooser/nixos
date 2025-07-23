# ZFS Configuration
# This module configures ZFS for mounting additional storage (not as root filesystem)

{ config, lib, pkgs, ... }:

{
  # Enable ZFS support
  boot.supportedFilesystems = [ "zfs" ];

  # ZFS services configuration
  services.zfs = {
    # Enable automatic scrubbing of all pools
    autoScrub = {
      enable = true;
      interval = "monthly";
      pools = [ "tank" ];
    };

    # Enable automatic snapshot service
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
    };
  };

  # Automatically import ZFS pools on boot
  boot.zfs = {
    # Force import pools (useful for pools that were not properly exported)
    forceImportRoot = false;
    forceImportAll = false;

    # Extra pool import flags
    extraPools = [ "tank" ];
  };

  # Install ZFS utilities
  environment.systemPackages = with pkgs; [
    zfs
  ];

  # Note: ZFS Event Daemon (ZED) configuration has been simplified in NixOS 25.05
  # Basic ZED functionality is automatically enabled with ZFS support
  # For advanced ZED configuration, you may need to manually configure /etc/zfs/zed.d/
}
