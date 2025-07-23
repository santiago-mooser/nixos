# Development Tools Configuration
# Python, Rust/Cargo, Neovim, and VSCode

{ config, lib, pkgs, ... }:

{
  # Development packages
  environment.systemPackages = with pkgs; [
    # Python with pip and common packages
    python3Full
    python3Packages.pip
    python3Packages.uv
    python3Packages.setuptools
    python3Packages.wheel

    # Rust toolchain
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy

    # Neovim with plugins
    neovim

    # Development utilities
    git

    # Archive tools
    p7zip
    unzip
    zip
    gnutar

    # Build tools
    gcc
    gnumake
    cmake
    pkg-config

    # Other useful development tools
    jq
    yq
    curl
    wget
    tree
    ripgrep
    fd
    tmux
    fzf
    zsh-z
  ];

  # Configure Neovim with basic plugins
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    configure = {
      customRC = ''
        " Basic Neovim configuration
        set number
        set relativenumber
        set tabstop=4
        set shiftwidth=4
        set expandtab
        set smartindent
        set wrap
        set ignorecase
        set smartcase
        set incsearch
        set hlsearch
        set scrolloff=8
        set sidescrolloff=8
        set mouse=a

        " Enable syntax highlighting
        syntax enable
        filetype plugin indent on

        " Set colorscheme
        colorscheme default

        " Key mappings
        let mapleader = " "
        nnoremap <leader>w :w<CR>
        nnoremap <leader>q :q<CR>
        nnoremap <leader>h :nohlsearch<CR>

        " Split navigation
        nnoremap <C-h> <C-w>h
        nnoremap <C-j> <C-w>j
        nnoremap <C-k> <C-w>k
        nnoremap <C-l> <C-w>l
      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          vim-nix
          vim-commentary
          vim-surround
          vim-fugitive
          fzf-vim
          lightline-vim
          rust-vim
        ];
      };
    };
  };

  # Install Rust using rustup for the santiago user
  users.users.santiago.packages = with pkgs; [
    rustup
  ];

  # Environment variables for development
  environment.variables = {
    EDITOR = "nvim";
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };

  # Enable direnv for project-specific environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
