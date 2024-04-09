{ pkgs }:

with pkgs; [
  # General packages for development and system management
  awscli2
  alacritty
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  gh
  killall
  neofetch
  openssh
  sqlite
  sqlitebrowser
  wget
  zip
  SDL2

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2
  # pinentry

  # Cloud-related tools and SDKs
  docker
  docker-compose
  rclone

  # Media-related packages
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf
  spotify

  # Node.js development tools
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs
  bun

  # Text and terminal utilities
  htop
  hunspell
  iftop
  fd
  fzf
  jetbrains-mono
  jq
  nixpkgs-fmt
  nixd
  ripgrep
  tree
  tmux
  unrar
  unzip
  zoxide
  zsh-powerlevel10k

  # Python packages
  python311
  python311Packages.virtualenv # globally install virtualenv
  python311Packages.pip
  poetry

  # Golang
  go
  gopls
]
