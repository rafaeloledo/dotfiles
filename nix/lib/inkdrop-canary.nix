{ pkgs, stdenv, fetchurl, coreutils, lib, ... }:

let
  deps = with pkgs; [
    libuuid
    libsecret
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk2
    gtk3
    libpulseaudio
    nspr
    nss
    pango
    stdenv.cc.cc
    udev
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
    xorg.libxkbfile
    libdrm
    libgbm
    libxkbcommon
    libGL
  ];
in

stdenv.mkDerivation rec {
  pname = "inkdrop";
  version = "6.0.0-canary.4";

  src = pkgs.fetchurl {
    url = "https://dist.inkdrop.app/releases/canary/inkdrop-${version}-amd64-linux.deb";
    hash = "sha256-viUABpxf8j3NJ/HqBFNaA9G/FXZT6nA3L0m1ISM977s=";
  };

  buildInputs = with pkgs; [
    dpkg
    makeWrapper
  ];

  dontBuild = true;

  unpackPhase = ''
    dpkg --fsys-tarfile $src | tar --extract
  '';

  installPhase = ''
    rm -r ./usr/share/doc

    mkdir -p $out
    cp -r ./opt $out
    cp -r ./usr/share $out

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      "$out/opt/Inkdrop/inkdrop-canary"

    wrapProgram $out/opt/Inkdrop/inkdrop-canary \
      --prefix LD_LIBRARY_PATH : "$out/opt/Inkdrop/inkdrop-canary" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath deps}"

    mkdir -p "$out/bin"
    ln -nfs "$out/opt/Inkdrop/inkdrop-canary" "$out/bin/inkdrop-canary"
  '';

  meta = {
    description = "Organizing your Markdown notes made simple";
    homepage = "https://www.inkdrop.app/";
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.rafaeloledo ];
    mainProgram = "inkdrop";
  };
}
