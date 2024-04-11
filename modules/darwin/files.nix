{ user, config, pkgs, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome   = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome  = "${config.users.users.${user}.home}/.local/state"; in
{
  "${xdg_configHome}/1Password/ssh/agent.toml" = {
    text = ''
      [[ssh-keys]]
      item = "github.com"
      vault = "Personal"

      [[ssh-keys]]
      item = "Disney SSH"
      vault = "Personal"

      [[ssh-keys]]
      item = "Unraid SSH"
      vault = "Personal"

      [[ssh-keys]]
      vault = "Personal"
    '';
  };
  ".mackup.cfg" = {
    text = ''
      [storage]
      engine = file_system
      path = Documents/prefs
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
