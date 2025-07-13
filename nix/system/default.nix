{ pkgs, lib, inputs, config, pkgs-unstable, ... }:

{
  imports = [
    ./hardware.nix
		./services.nix
    ./libinput.nix
    /home/rgnh55/disk.nix
    ./serve.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
    ];
    trusted-substituters = [
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  swapDevices = [ ];

  # Real Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.polkit.enable = true;

  # VM
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/sda";
  # boot.loader.grub.useOSProber = true;

  services.lvm.enable = false;
  hardware.graphics.enable32Bit = true;
  systemd.enableEmergencyMode = false;

  programs.adb.enable = true;

  users.defaultUserShell = pkgs.bash;
  users.users.rgnh55 = {
    isNormalUser = true;
    description = "rgnh55";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "tss" "docker" "adbusers"];
    packages = with pkgs; [
      obs-studio
      scrcpy
    ];
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  programs.hyprland.xwayland.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.fish.enable = true;
  programs.virt-manager.enable = true;
  programs.noisetorch.enable = true;

  time.timeZone = "America/Bahia";
  time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  security.rtkit.enable = true;
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;

  environment.shells = with pkgs; [ bash fish ];

  environment.sessionVariables = rec {
    GTK_SCALE = "1";
    # VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.nvidiad/nvidia_icd.x86_64.json";
    NIXOS_OZONE_WL = "1";
  };

  services = {
    power-profiles-daemon.enable = true;
    tlp.enable = false;
    flatpak.enable = true;
  };

  environment.systemPackages = with pkgs; [
    i7z
    unzip
    killall
    egl-wayland
    gcc
    gnumake
    git
    cmake
    wget
    libtool
    spice-vdagent
		blueman
		cloudflared
    vim
    networkmanagerapplet
    hydra-check

    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];

  system.stateVersion = "25.05";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  networking.firewall.allowedTCPPorts = [
    22
    80

    5432
    5173

    3000

    8000
    8080
    8081
    8082
    8096

    5000
    5001
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking = {
    networkmanager.enable = true;
    hostName = "nixos";
    useDHCP = lib.mkDefault true;
    nat.enable = true;
  };

  fonts.packages =
    # with pkgs-unstable;
    with pkgs;
    [
    roboto-mono
    noto-fonts-cjk-sans
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-serif
    ubuntu_font_family
    nerd-fonts.jetbrains-mono
    fira-code
    nerd-fonts.hack
  ];

  # services.xserver.windowManager.i3.enable = true;

  users.groups.docker = {};
	virtualisation.docker = {
		enable = true;
		daemon.settings = {
			data-root = "~/docker/img";
		};
	};

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "postgres" "rgnh55" ];
    enableTCPIP = true;
    settings.port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
      local all       all     trust
      host  all      all     127.0.0.1/32   trust
    '';
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
