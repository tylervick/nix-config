{ config, pkgs, lib, home-manager, ... }:

let
  user = "tyler.vick.-nd";
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
   ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    
    brews = pkgs.callPackage ./brews.nix {};

    casks = pkgs.callPackage ./casks.nix {};

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    masApps = {
      "microsoft-remote-desktop" = 1295203466;
      #"1password" = 1333542190;
      #"wireguard" = 1451685025;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];
        stateVersion = "23.11";
      };
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;

      imports = [
        ./trampoline
      ];
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    { path = "/Applications/Firefox.app/"; }
    { path = "/Applications/Slack.app/"; }
    { path = "/System/Applications/Home.app/"; }
    { path = "/Applications/Visual Studio Code.app/"; }
    { path = "/Applications/Xcode.app/"; }
    { path = "/Applications/Sublime Text.app/"; }
    { path = "/Applications/Obsidian.app/"; }
    { path = "${pkgs.iterm2}/Applications/iTerm2.app/"; }
    {
      path = "${config.users.users.${user}.home}/Downloads";
      section = "others";
      options = "--sort name --view grid --display folder";
    }
    # {
    #   path = "${config.users.users.${user}.home}/.local/share/downloads";
    #   section = "others";
    #   options = "--sort name --view grid --display stack";
    # }
  ];

}
