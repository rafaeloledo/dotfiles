{
  services.nix-serve = {
    enable = true;
    port = 5000;
    bindAddress = "192.168.0.12";
    secretKeyFile = "/home/rgnh55/priv.pem";
  };
}
