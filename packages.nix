{
  pkgs,
  pkgs-stable,
  pkgs-master,
  config,
  lib,
  ...
}: let
  versions = builtins.fromJSON (builtins.readFile (./. + "/versions.json"));
  
  my_pkgs = import ./my-pkgs.nix {
    inherit pkgs config versions;
  };

  packages_dict = with pkgs; {
    desktop = {
      cli = [
        # cyrus-sasl-xoauth2
        # isync-oauth2
        # mailctl
        oauth2ms
      ];
    };
  };

  packages = with pkgs; {
    cli = [
    ];
  };
in {
  home.packages =
    packages.cli
    ++ builtins.concatLists (lib.attrsets.collect builtins.isList packages_dict);

  nixpkgs.overlays = [(self: super: {
    cyrus-sasl-xoauth2 = super.pkgs.stdenv.mkDerivation {
      pname = "cyrus-sasl-xoauth2";
      version = "master";

      src = super.pkgs.fetchFromGitHub {
        owner = "moriyoshi";
        repo = "cyrus-sasl-xoauth2";
        rev = "master";
        sha256 = "sha256-OlmHuME9idC0fWMzT4kY+YQ43GGch53snDq3w5v/cgk=";
      };

      nativeBuildInputs = [super.pkg-config super.automake super.autoconf super.libtool];
      propagatedBuildInputs = [super.cyrus_sasl];

      buildPhase = ''
        ./autogen.sh
        ./configure
      '';

      installPhase = ''
        make DESTDIR="$out" install
      '';

      meta = {
        homepage = "https://github.com/moriyoshi/cyrus-sasl-xoauth2";
        description = "XOAUTH2 mechanism plugin for cyrus-sasl";
      };
    };

    mailctl = super.pkgs.stdenv.mkDerivation {
        pname = "mailctl";
        version = "master";
        
        src = super.pkgs.fetchFromGitHub {
          owner = "pdobsan";
          repo = "mailctl";
          rev = "master";
          sha256 = "sha256-R7yR0lBmP9fE9oFy3rDssn2+mobeJwULhFfOa4pIRr0";
        };

        nativeBuildInputs = [super.haskell.compiler.ghc943   super.cabal-install super.zlib];
        # propagatedBuildInputs = [super.cyrus_sasl];
        
        buildPhase = ''
        export HOME=$TMP
        cabal update
        cabal install --install-method=copy
        '';
        
        installPhase = ''
          mkdir -p "$out/bin"  
          cp -r $HOME/.cabal/bin $out
        '';     
    };

    oauth2ms = super.pkgs.stdenv.mkDerivation {
      pname = "oauth2ms";
      version = "2021-07-09";
      
      src = super.pkgs.fetchFromGitHub {
        owner = "gavinschenk";
        repo = "oauth2ms";
        rev = "07b06f0d368ddb96698e88d05a27936759b4a02c"; # No tags or releases in the repo
        sha256 = "sha256-mIOiF3i/XkOHgoR1pZ3HSPa6E/Fh7Ukce+ud2ma2LSQ=";
      };
      
      buildInputs = [
        (super.pkgs.python3.withPackages (ps: with ps; [
          pyxdg
          msal
          python-gnupg
        ]))
      ];

      installPhase = ''
                 runHook preInstall
                 install -m755 -D oauth2ms $out/bin/oauth2ms
                 runHook postInstall
                 '';
    };

    
    # https://github.com/NixOS/nixpkgs/issues/108480#issuecomment-1115108802
    isync-oauth2 = super.buildEnv {
      name = "isync-oauth2";
      paths = [super.isync];
      pathsToLink = ["/bin"];
      nativeBuildInputs = [super.makeWrapper];
      postBuild = ''
        wrapProgram "$out/bin/mbsync" \
          --prefix SASL_PATH : "${super.cyrus_sasl.out.outPath}/lib/sasl2:${self.cyrus-sasl-xoauth2}/usr/lib/sasl2"
      '';
    };
  })];
  

}
