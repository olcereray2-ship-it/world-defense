{ pkgs }: {
  deps = [
    pkgs.bash
    pkgs.curl
    pkgs.unzip
    pkgs.jdk17
    pkgs.coreutils
    pkgs.glib
    pkgs.glibc
    pkgs.zlib
    pkgs.xorg.libX11
    pkgs.xorg.libXcursor
    pkgs.xorg.libXinerama
    pkgs.xorg.libXi
    pkgs.xorg.libXrandr
  ];
}
