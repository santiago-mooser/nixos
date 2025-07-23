# Applications Configuration
# Firefox, Signal, and 1Password

{ config, lib, pkgs, ... }:

{
  # Install applications
  environment.systemPackages = with pkgs; [
    _1password-cli
  ];

  # 1Password integration
  programs._1password = {
    enable = true;
  };
}
