{
  pkgs,
  config,
  versions,
  ...
}:
with pkgs; let
  mailctl = stdenv.mkDerivation {
    pname = "mailctl";
    version = versions.mailctl.version;
    src = fetchurl {
      url = versions.mailctl.url;
      sha256 = versions.mailctl.sha;
    };

    unpackPhase = ":";
    installPhase = ''
      install -m755 -D $src $out/bin/mailctl
    '';

    meta = {
      homepage = "https://github.com/pdobsan/mailctl";
      description = "Provide IMAP/SMTP clients with the capabilities of renewal and authorization of OAuth2 credentials";
    };
  };
in {
  mailctl = mailctl;
}
