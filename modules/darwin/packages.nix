{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; };  in
shared-packages ++ [
  dockutil
  darwin.xcode_15_1
  rectangle
  iterm2
  tart
]
