{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, asciidoc, libxslt, docbook_xsl
, wayland, wayland-protocols, xwayland, wlroots, libxkbcommon, pcre, json_c, dbus
, pango, cairo, libinput, libcap, pam, gdk_pixbuf, libpthreadstubs
, libXdmcp
, buildDocs ? true
}:

stdenv.mkDerivation rec {
  name = "sway-${version}";
  version = "trunk";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "e86d99acd655815781cd2e23877ce58ab5b24826";
    sha256 = "0g4r0hk540bxmlppnibsaph05m3rjqzdjg6ljhiskd1na1gg7smr";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig
  ] ++ stdenv.lib.optional buildDocs [ asciidoc libxslt docbook_xsl ];
  buildInputs = [
    wayland wayland-protocols xwayland wlroots libxkbcommon pcre json_c dbus
    pango cairo libinput libcap pam gdk_pixbuf libpthreadstubs
    libXdmcp
  ];
  mesonFlags = "-Dsway_version=${version}";

  enableParallelBuilding = true;

  cmakeFlags = "-DVERSION=${version} -DLD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib";

  meta = with stdenv.lib; {
    description = "i3-compatible window manager for Wayland";
    homepage    = http://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ]; # Trying to keep it up-to-date.
  };
}
