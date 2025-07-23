# Docker Configuration
# Docker daemon and Docker Compose

{ config, lib, pkgs, ... }:

{
  # Enable Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    # Docker daemon configuration
    daemon.settings = {
      # Enable experimental features
      experimental = false;

      # Set default logging driver
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };

      # Enable live restore (containers keep running during daemon upgrades)
      live-restore = true;

      # Default runtime
      default-runtime = "runc";

      # Storage driver (overlay2 is recommended)
      storage-driver = "overlay2";
    };

    # Enable rootless Docker for the santiago user (optional, more secure)
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Install Docker Compose and other Docker tools
  environment.systemPackages = with pkgs; [
    docker-compose
    docker-buildx
    dive # Tool for exploring docker images
    ctop # Top-like interface for containers
    lazydocker # Simple terminal UI for docker
  ];

  # Add santiago user to docker group
  users.users.santiago.extraGroups = [ "docker" ];

  # Enable container networking (for Docker)
  networking.firewall.trustedInterfaces = [ "docker0" ];

  # Enable BuildKit by default (more efficient builds)
  environment.sessionVariables = {
    DOCKER_BUILDKIT = "1";
    COMPOSE_DOCKER_CLI_BUILD = "1";
  };

  # Configure logrotate for Docker logs
  services.logrotate = {
    enable = true;
    settings = {
      "/var/lib/docker/containers/*/*-json.log" = {
        rotate = 7;
        daily = true;
        compress = true;
        missingok = true;
        delaycompress = true;
        copytruncate = true;
      };
    };
  };

  # Docker cleanup service (removes unused containers, images, etc.)
  systemd.services.docker-cleanup = {
    description = "Clean up Docker resources";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "${pkgs.docker}/bin/docker system prune -af --volumes";
    };
  };

  # Timer for Docker cleanup (runs weekly)
  systemd.timers.docker-cleanup = {
    description = "Clean up Docker resources weekly";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };
}
