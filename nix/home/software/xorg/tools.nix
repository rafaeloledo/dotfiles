{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    maim
    xclip
  ];
}
