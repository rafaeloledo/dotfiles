{
  services.nix-serve = {
    enable = true;
    port = 5000;
    bindAddress = "192.168.0.25";
    secretKeyFile = "/var/cache-priv-key.pem";
  };
}
