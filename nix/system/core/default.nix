{
  pkgs,
  options,
  config,
  lib,
  ...
}:

{
  imports = [ ./libinput.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  systemd.enableEmergencyMode = false;

  users = {
    users.rgnh55 = {
      isNormalUser = true;
      description = "rgnh55";
      shell = pkgs.fish;
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "tss" ];
      packages = with pkgs; [
        kdePackages.kate scrcpy android-studio 
      ];
    };
    defaultUserShell = pkgs.fish;
  };

  programs = {
    fish.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    firefox.enable = true;

    virt-manager.enable = true;
    noisetorch.enable = true;
  };

  time.timeZone = "America/Bahia";
  time.hardwareClockInLocalTime = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  security = {
    rtkit.enable = true;
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };

  environment.shells = with pkgs; [ bash fish ];
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" ]; })
  ];

  environment.sessionVariables = rec {
    GTK_SCALE = "1";
    VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
  };

  services = {
    power-profiles-daemon.enable = true;
    tlp.enable = false;
    flatpak.enable = true;
  };

  environment.systemPackages = with pkgs; [
		pamixer
		pavucontrol
    linuxKernel.packages.linux_6_9.turbostat
    i7z
    unzip
    xorg.xbacklight
    kdePackages.powerdevil
    fish
		zsh
    cachix
    nvtopPackages.full
    killall
    egl-wayland
        gcc
    gnumake
    cmake
    wget
    libtool
    ntfs3g
    spice-vdagent
		blueman
		cloudflared
  ];
  system.stateVersion = "24.05";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
