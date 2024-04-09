{ agenix, config, pkgs, lib, ... }:

let user = "tyler"; in

{

  imports = [
    ../../modules/darwin/secrets.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
    ../../modules/shared/cachix
    agenix.darwinModules.default
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Activate the system at boot time
  services.activate-system.enable = true;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nixUnstable;
    settings.trusted-users = [ "@admin" "${user}" ];

    gc = {
      user = "root";
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs; [
    agenix.packages."${pkgs.system}".default
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  # Enable fonts dir
  fonts.fontDir.enable = true;

  launchd.user.agents.emacs.path = [ config.environment.systemPath ];
  launchd.user.agents.emacs.serviceConfig = {
    KeepAlive = true;
    ProgramArguments = [
      "/bin/sh"
      "-c"
      "/bin/wait4path ${pkgs.emacs}/bin/emacs && exec ${pkgs.emacs}/bin/emacs --fg-daemon"
    ];
    StandardErrorPath = "/tmp/emacs.err.log";
    StandardOutPath = "/tmp/emacs.out.log";
  };

  networking = {
    computerName = "KPWGV9WGPG";
    hostName = "KPWGV9WGPG";
  };

  system = {
    stateVersion = 4;

    defaults = {

      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };

      # "com.apple.desktopservices" = {
      #   DSDontWriteNetworkStores = true; # Don't store DS_Store in networked drives
      # };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true; # Show hidden files
        ApplePressAndHoldEnabled = false;
        AppleKeyboardUIMode = 3; # Full keyboard access for all controls
        NSAutomaticSpellingCorrectionEnabled = true; # Enable auto-correct
        NSAutomaticQuoteSubstitutionEnabled = false; # Turn off "smart" quotes
        NSDocumentSaveNewDocumentsToCloud = false; # Disable save dialog defaulting to iCloud
        PMPrintingExpandedStateForPrint = true; # Expand print panel by default
        PMPrintingExpandedStateForPrint2 = true;
        NSNavPanelExpandedStateForSaveMode = true; # Expand save panel by default
        NSNavPanelExpandedStateForSaveMode2 = true;
        "com.apple.mouse.tapBehavior" = 1; # Enable tap to click
        AppleMeasurementUnits = "Inches";
        AppleMetricUnits = 0;
        # 120, 90, 60, 30, 12, 6, 2
        # KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        # InitialKeyRepeat = 15;

        # "com.apple.mouse.tapBehavior" = 1;
        # "com.apple.sound.beep.volume" = 0.0;
        # "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        orientation = "left";
        tilesize = 48;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false; # Disable warning when changing file extensions
        FXPreferredViewStyle = "clmv";
      };

      universalaccess = {
        closeViewScrollWheelToggle = true; # Use scroll gesture with the Ctrl (^) modifier key to zoom
        # HIDScrollZoomModifierMask = 262144;
        closeViewZoomFollowsFocus = true; # Follow cursor while zoomed
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };

      CustomUserPreferences = {
        "com.apple.finder" = {

        };

        "com.bjango.istatmenus6.extras.plist" = {
          "Battery_ColorGraphAirpods-Standard" = "0.00 0.83 0.00 1.00";
          "Battery_ColorGraphAirpodsLow-Standard" = "1.00 0.00 0.00 1.00";
          "Battery_ColorGraphBluetooth-Standard" = "0.00 0.83 0.00 1.00";
          "Battery_ColorGraphBluetoothLow-Standard" = "1.00 0.00 0.00 1.00";
          "Battery_ColorGraphShowIcons" = 1;
          "Battery_DropdownOrderDisabled" = "";
          # "Battery_MenubarMode" = [
          #   {
          #     "key" = "4";
          #     "uuid" = "C8A29EF5-87CA-44EA-82E9-139E8EBF8CAA";
          #   }
          #   {
          #     "key" = "0";
          #     "uuid" = "AA1FB648-4B40-4A6F-8348-77C015C81A84";
          #   }
          # ];
        };
      };

      CustomSystemPreferences = {
        NSGlobalDomain = {
          AppleLanguages = [ "en" "US" ];
          AppleLocale = "en_US@currency=USD";
          NSUseSpellCheckerForCompletions = false;
        };

        "com.apple.finder" = {
          NewWindowTarget = "PfLo";
          NewWindowTargetPath = "file://\$\{HOME\}/";
          ShowExternalHardDrivesOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          QLEnableTextSelection = true; # Allow text-selection in Quick Look
        };

        "com.apple.Safari" = {
          IncludeInternalDebugMenu = true;
          IncludeDevelopMenu = true;
          WebKitDeveloperExtrasEnabledPreferenceKey = true;
          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
          UniversalSearchEnabled = false;
          AutoOpenSafeDownloads = false;
        };
      };
    };

    keyboard = {
      enableKeyMapping = true;
    };

    activationScripts = {
      extraActivation.text = lib.mkBefore ''
        # # Outdated on High Sierra
        # # Show item info to the right of the icons on the desktop
        # echo "Setting desktop icon settings"
        # # /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

        # # Enable snap-to-grid for icons on the desktop and in other icon views
        # /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
        # /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
        # /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist

        # # Increase grid spacing for icons on the desktop and in other icon views
        # /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
        # /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
        # /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

        # # Increase the size of icons on the desktop and in other icon views
        # /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 16" ~/Library/Preferences/com.apple.finder.plist
        # /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 16" ~/Library/Preferences/com.apple.finder.plist
        # /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 16" ~/Library/Preferences/com.apple.finder.plist
      '';
    };
  };

  security.pam.enableSudoTouchIdAuth = true;
}