{ pkgs ? import <nixpkgs> {}, lib ? pkgs.lib }:

pkgs.writeShellScriptBin "gradle" ''
  ${lib.getExe pkgs.gradle} $GRADLE_OPTS "$@"
''
