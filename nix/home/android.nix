{ config, pkgs, ... }:

let
  androidSdkModule = import ((builtins.fetchGit {
    url = "https://github.com/rafaeloledo/android-nixpkgs.git";
    ref = "main";  # Or "stable", "beta", "preview", "canary"
  }) + "/hm-module.nix");

in
{
  imports = [ androidSdkModule ];

  android-sdk.enable = true;

  # Optional; default path is "~/.local/share/android".
  android-sdk.path = "${config.home.homeDirectory}/.android/sdk";

  android-sdk.packages = sdkPkgs: with sdkPkgs; [
    cmdline-tools-latest
    build-tools-30-0-0
    platform-tools
    platforms-android-30
    emulator
  ];
}
