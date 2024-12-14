{
  pkgs,
  ... 
}:

{
  imports = [
    ./devops.nix
    ./programming-languages.nix
    ./terminal.nix
    ./frameworks.nix
  ];

  home.packages = with pkgs; [
    xorg.libXrender

    picom
    dunst
    duf
    rofi
    viewnior
    davinci-resolve
    nodePackages.live-server

    rnnoise-plugin
    rnnoise
  ];
}
