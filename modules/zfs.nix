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

    # Request encryption credentials for encrypted datasets
    requestEncryptionCredentials = [ "tank" ];
  };

  # Systemd service to automatically unlock ZFS encrypted datasets using keyfile
  systemd.services.zfs-load-key = {
    description = "Load ZFS encryption keys";
    wantedBy = [ "zfs-mount.service" ];
    after = [ "zfs-import.target" ];
    before = [ "zfs-mount.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";  # Explicitly run as root to access /root/.keys/
      ExecStart = pkgs.writeScript "zfs-load-key" ''
        #!${pkgs.bash}/bin/bash

        # Check if keyfile exists
        if [ -f /root/.keys/zfs.key ]; then
          # Load key for tank pool (adjust dataset name as needed)
          ${pkgs.zfs}/bin/zfs load-key -L file:///root/.keys/zfs.key -a tank
        else
          echo "Warning: ZFS keyfile not found at /root/.keys/zfs.key"
          exit 1
        fi
      '';
    };
  };

  # Install ZFS utilities
  environment.systemPackages = with pkgs; [
    zfs
  ];

  # Note: ZFS Event Daemon (ZED) configuration has been simplified in NixOS 25.05
  # Basic ZED functionality is automatically enabled with ZFS support
  # For advanced ZED configuration, you may need to manually configure /etc/zfs/zed.d/
}
