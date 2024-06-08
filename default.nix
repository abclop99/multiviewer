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
    url = "https://releases.multiviewer.app/download/${id}/MultiViewer.for.F1-linux-x64-${version}.zip";
    sha256 = "sha256-Q8n7qsmQQqcItNls4GbLePu3RkjX1QbF2VX13PapJ+8=";
  };

  desktop_file = pkgs.fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/f1multiviewer.desktop?h=f1multiviewer-bin";
    sha256 = "sha256-AN2cqNlKcpuAEl9vnuIofM0/hpdTOMXOHRJXUTDXOmo=";
  };

  nativeBuildInputs = with pkgs; [
    unzip
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
    # dpkg --fsys-tarfile $src | tar --extract
    unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    # Create main directories
    mkdir -p $out/bin $out/share

    # Install desktop file
    mkdir -p $out/share/applications
    cp -t $out/share/applications $desktop_file

    # Install the application itself
    mkdir -p $out/share/multiviewer-for-f1
    mv -t $out/share/multiviewer-for-f1 MultiViewer\ for\ F1-linux-x64/*

    # Install icon
    mkdir -p $out/share/pixmaps
    cp -T $out/share/multiviewer-for-f1/resources/app/.webpack/main/88a36af69fdc182ce561a66de78de7b1.png $out/share/pixmaps/f1multiviewer.png

    # Install bin
    makeWrapper "$out/share/multiviewer-for-f1/MultiViewer for F1" $out/bin/multiviewer-for-f1 \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" \
      --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.libudev0-shim ]}:\"$out/share/Multiviewer for F1\""

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Unofficial desktop client for F1 TV®";
    homepage = "https://multiviewer.app";
    downloadPage = "https://multiviewer.app/download";
    license = licenses.unfree;
    maintainers = with maintainers; [ abclop99 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "multiviewer-for-f1";
  };
}
