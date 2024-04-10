{ user, config, pkgs, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome   = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome  = "${config.users.users.${user}.home}/.local/state"; in
{
  ".mackup.cfg" = {
    text = ''
      [storage]
      engine = file_system
      path = Documents
      directory = mackup
      [applications_to_sync]
      bartender
      rclone
      istat-menus
      hammerspoon
      fork
      spotify
    '';
  };
}
