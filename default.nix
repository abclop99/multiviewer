{ 
  pkgs,
}:
let
  id = "168727397";
in
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "multiviewer-for-f1";
  version = "1.32.1";

  src = pkgs.fetchurl {
    url = "https://releases.multiviewer.dev/download/${id}/multiviewer-for-f1_${version}_amd64.deb";
    # sha256 = "sha256-lFES+ukkI/GqKQdZwtaB+ov0hqAyFZ2N533LBKJ9oXg=";
    sha256 = builtins.convertHash {
      hash = "43c9fbaac99042a708b4d96ce066cb78fbb74648d7d506c5d955f5dcf6a927ef";
      toHashFormat = "sri";
      hashAlgo = "sha256";
    };
  };

  nativeBuildInputs = with pkgs; [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    ffmpeg
    glib
    gtk3
    libdrm
    libxkbcommon
    mesa
    nspr
    nss
    pango
    xorg.libX11
    xorg.libXcomposite
    xorg.libxcb
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    runHook preUnpack

    # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
    dpkg --fsys-tarfile $src | tar --extract

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    mv -t $out/share usr/share/* usr/lib/multiviewer-for-f1

    makeWrapper "$out/share/multiviewer-for-f1/MultiViewer for F1" $out/bin/multiviewer-for-f1 \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" \
      --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.libudev0-shim ]}:\"$out/share/Multiviewer for F1\""

    runHook postInstall
  '';

  # meta = with lib; {
  #   description = "Unofficial desktop client for F1 TV®";
  #   homepage = "https://multiviewer.app";
  #   downloadPage = "https://multiviewer.app/download";
  #   license = licenses.unfree;
  #   maintainers = with maintainers; [ babeuh ];
  #   platforms = [ "x86_64-linux" ];
  #   mainProgram = "multiviewer-for-f1";
  # };
}
