{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; };  in
shared-packages ++ [
  # TODO: Need a better way to add Xcode instead of darwin.xcode
  dockutil
  rectangle
  iterm2
  tart
]
