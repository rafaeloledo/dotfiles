{ pkgs, inputs, ... }:

{
  environment.systemPackages = [
    inputs.hyprswitch.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
