{ pkgs, ... }:

{
  services.udev.packages = [
    (
      pkgs.writeTextFile {
        name = "sunshine-udev-rules";
        text = ''
          KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
        '';
        destination = "/etc/udev/rules.d/85-sunshine-input.rules";
      }
    )
  ];
}
