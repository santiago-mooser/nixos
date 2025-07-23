# Shell Configuration
# Zsh with Oh-my-zsh

{ config, lib, pkgs, ... }:

{
  # Enable Zsh system-wide
  programs.zsh = {
    enable = true;

    # Oh-my-zsh configuration
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "docker-compose"
        "rust"
        "python"
        "npm"
        "yarn"
        "node"
        "vscode"
        "tailscale"
        "systemd"
        "history-substring-search"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
      ];
      theme = "robbyrussell";
      custom = "$HOME/.oh-my-zsh/custom";
    };

    # Additional Zsh configuration
    shellInit = ''
      # Custom aliases
      alias ll='ls -alF'
      alias la='ls -A'
      alias l='ls -CF'
      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'

      # Git aliases
      alias gs='git status'
      alias ga='git add'
      alias gc='git commit'
      alias gp='git push'
      alias gl='git log --oneline'
      alias gd='git diff'

      # Docker aliases
      alias d='docker'
      alias dc='docker-compose'
      alias dps='docker ps'
      alias di='docker images'

      # System aliases
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      alias h='history'
      alias c='clear'

      # NixOS aliases
      alias nrs='sudo nixos-rebuild switch'
      alias nrt='sudo nixos-rebuild test'
      alias nrb='sudo nixos-rebuild boot'
      alias nfu='nix flake update'
      alias nfc='nix flake check'

      # ZFS aliases
      alias zpl='zpool list'
      alias zps='zpool status'
      alias zfl='zfs list'
      alias zfm='zfs mount -a'

      # Tailscale aliases
      alias ts='tailscale'
      alias tss='tailscale status'
      alias tsu='tailscale up'
      alias tsd='tailscale down'
    '';

    # Environment variables
    shellAliases = {
      # Additional system aliases
      "update-system" = "sudo nixos-rebuild switch";
      "search-pkg" = "nix-env -qaP";
    };

    # History configuration
    histSize = 10000;
    histFile = "$HOME/.zsh_history";

    # Auto-completion
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Install additional shell packages
  environment.systemPackages = with pkgs; [
    # Zsh plugins (will be managed by Oh-my-zsh)
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search

    # Terminal utilities
    direnv # Environment variable management
    fzf # Fuzzy finder

    # Terminal multiplexer
    tmux

    # System monitoring
    htop
    glances

    # Network tools
    nmap
    wget
    curl
  ];

  # Set default shell for santiago user
  users.users.santiago.shell = pkgs.zsh;

  # Enable command-not-found for helpful suggestions
  programs.command-not-found.enable = true;
}
