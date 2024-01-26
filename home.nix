{ config, pkgs, stdenv, lib,  ... }:

let
  # emacs-overlay = fetchTarball {
  #   url = https://github.com/nix-community/emacs-overlay/archive/a46829010dd9d129fd930ae76aba9f09b4160630.tar.gz;
  # };
  nixos = import <nixos> { };
in
{
  imports = [
    ./packages.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "xmarvl";
  home.homeDirectory = "/Users/xmarvl";
  home.language = {
    base = "en_US";
  };

  home.sessionVariables = {
    EDITOR = "emacsclient";
  };

  home.file = {
    ".emacs" = {
      source = programs/emacs/emacs;
    };
    "bin/installfonts" = {
      source = programs/installfonts/installfonts;
    };
    ".ssh/config" = {
      source = programs/ssh/config;
    };
    ".config/oauth2ms/config.json" = {
      source = programs/oauth2ms/config.json;
    };
    ".config/oauth2ms/config-2.json" = {
      source = programs/oauth2ms/config-2.json;
    };
    ".imbib" = {
      source = programs/imbib/imbib;
    };
    ".mailcap" = {
      source = programs/mailcap/mailcap;
    };
    # ".agda/defaults" = {
    #   source = programs/agda/defaults;
    # };
  };


    
  launchd.enable = true;
  launchd.agents = {
    mbsync = {
      enable = true;
      config = {
        KeepAlive = true;
        ProgramArguments = [ "mbsync" "-a" ];
        ThrottleInterval = 180;
        StartOnMount = true;
      };      
    };
  };
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
  manual.manpages.enable = false;

  nixpkgs = {
    config.allowUnfree = true; # for things like spotify
    # overlays
    overlays = [
      (import (builtins.fetchTarball {
        # url = https://github.com/nix-community/emacs-overlay/archive/bdc9dc52f1ae9772ebdca1f132554fe548392001.tar.gz;
        url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      }))
    ];
  };

  programs.java = { enable = true; package = pkgs.openjdk8; };


  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
    experimental-features = nix-command flakes
    substituters = https://cache.nixos.org https://nix-community.cachix.org
    trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
      '';
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  home.packages = let
    agda-stuff = (pkgs.agda.withPackages (with pkgs; [
      agdaPackages.standard-library
    ]));
    haskell-packages = pkgs.haskell.packages.ghc961.ghcWithPackages (ps: with ps; ([
      cabal-install
    ]));
    python-packages = py-pkgs: with py-pkgs; [
      nltk
      python-lsp-server
      black
      build
      pyflakes
      rope
      pycodestyle
      pydocstyle
      setuptools
      pip
      #  pytorch
      # numpy
      # pandas
      # pygments
      # scikit-learn
      # tensorflowWithoutCuda
    ];
    python-stuff = pkgs.python38.withPackages python-packages;
    aspell-with-dicts  = pkgs.aspellWithDicts (d: [d.en]);
    tex = (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic
        adjustbox
        algorithm2e
        acmart
        biber
        biblatex
		    biblatex-apa
        biblatex-trad
        boondox
        catchfile
        changepage
        collection-fontsrecommended
        collectbox
        covington
        comment
        csquotes
        cleveref
        datatool
        datetime
        doublestroke
        ebproof
        environ
        enumitem
			  eqparbox
        fontaxes
        fmtcount
        framed
        fvextra
        glossaries
        glossaries-english
        harvard
        hyperxmp
        ifplatform
        ifsym
        imakeidx
        inconsolata
        kastrup
        latexmk
        libertine
        listings
        lm
        logreq
		    ltablex
        luacode
        mathpartir
        mathastext
        minted
        makecell
        mfirstuc
        multirow
        memoir
        mweights
        ncclatex
        ncctools
        newtx
        newtxsf
        newtxtt
        newunicodechar
        paralist
        pgfgantt
        preprint
        prftree
        pst-tree
        pst-node
        pstricks
        relsize
        siunitx
        sectsty
        scheme-small wrapfig marvosym wasysym
        soul
        standalone
        stmaryrd
        sttools
        svg
        lazylist polytable # lhs2tex
        tabulary
        titling
        titlesec
        todonotes
        totpages
        tracklang
        transparent
        trimspaces
        thmtools
        ucs
        varwidth
        wasy cm-super unicode-math filehook lm-math capt-of
        xargs
        xindy
        xstring ucharcat
        xfor
        xypic
        xpatch
        xurl
        xifthen
        ifmtarg
        ifoddpage

      ;
    });
  in
    with pkgs;
    [
      # agda-stuff # agda + packages
      ant
      aspell-with-dicts
      cachix
      clang
      dotnet-sdk_6
      git-lfs
      github-cli
      gnuplot
      gradle
      imagemagick
      inkscape
      ledger
      ltex-ls
      nodejs nodePackages.yarn nodePackages.prettier nodePackages.typescript nodePackages.typescript-language-server nodePackages.sass nodePackages.vscode-langservers-extracted nodePackages.gatsby-cli 
      openssl
      omnisharp-roslyn
      pass
      passff-host
      perl
      pinentry
      php
      plantuml
      python-stuff
      redis
      # haskell-packages
      terminal-notifier
      tex
      tree
      iterm2
      ffmpeg
      wget

      vips
      youtube-dl
    ];

  programs.git = {
    enable = true;
    userEmail = "vlad@maraev.me";
    userName = "Vladislav Maraev";
    signing = {
      key = "0A6A67D83FBD77DB";
      signByDefault = true;
    };
    extraConfig = {
      github.user = "vladmaraev";
    };
  };
  programs.gpg.enable = true;
  # programs.fish.enable = true;
  programs.k9s.enable = true;
  programs.mu.enable = true;
  programs.msmtp = {
    enable = true;
  };
  programs.mbsync = {
    enable = true;
    package = pkgs.isync-oauth2;
  };

  programs.emacs = {                              
    enable = true;
    package = pkgs.emacs-unstable;
    extraPackages = import ./emacs.nix { inherit pkgs; };
    overrides = self: super: {
      semantic-theming = self.trivialBuild {
        pname = "emacs-semantic-theming";
        version = "0.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "vladmaraev";
          repo = "emacs-semantics-theming";
          rev = "4fdf2b7688ca3a4fd2430de079bbd09cd5247da6";
          sha256 = "sha256-jtwhaDXXj7xhB4gfkjNDqGPhlrx+9l2LDCcVQ6RUm4A=";
        };
        buildPhase = "";
      };
      tree-sitter-langs-bugfix = self.trivialBuild {
        pname = "tree-sitter-langs";
        version = "0.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "domq";
          repo = "tree-sitter-langs";
          rev = "9951fcf93f15e9b238ad8f6776af93cad7d2141f";
          sha256 = "sha256-oUMSw6+UX1lrNLIQO0PttbOGNkKCgl8y6DIDVUzgg/c=";
        };
        buildPhase = "";
      };

      thread-folding = self.trivialBuild {
        pname = "mu4e-thread-folding";
        version = "0.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "rougier";
          repo = "mu4e-thread-folding";
          rev = "b95cd5f4587d458e9578708cf1101be5c2e3c8f8";
          sha256 = "sha256-ZF6i/32iFXfeXTPCT/LPFpXmboZ3tpdB+GDs6T9IwfA=";
        };
        buildPhase = "";
      };
      nano-emacs = self.trivialBuild {
        pname = "nano-emacs";
        version = "0.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "rougier";
          repo = "nano-emacs";
          rev = "c313957b5945e197c7d9cab1115190a339ee856c";
          sha256 = "sha256-GX9bRdYExcfKsoc6fTnihjz1eaulri7AIxDIQLNhaRI=";
        };                 
        buildPhase = "";
      };
      agda-input = self.trivialBuild {
        pname = "agda-input";
        version = "0.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "agda";
          repo = "agda";
          rev = "v2.6.2.2";
          sha256 = "sha256-/Hmgy3W8cdtSW0Sz4G53swAq//q6hPxW4OSG401pU08=";
        } + "/src/data/emacs-mode/";
        buildPhase = "";
      };
    };
  };

  
  accounts.email = {
    accounts.gu = {
      primary = true;
      address = "vladislav.maraev@gu.se";
      realName = "Vladislav Maraev";

      imap.host = "outlook.office365.com";
      imap.tls.certificatesFile = ~/.cert/outlook.office365.com.pem;

      imapnotify.enable = true;
      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "both";
        extraConfig.account = {
          AuthMechs = "XOAUTH2";
        };
      };
      msmtp.enable = true;
      mu.enable = true;
      userName = "vladislav.maraev@gu.se";
      passwordCommand = "oauth2ms --config=config.json";
      smtp = {
        host = "smtp.office365.com";
        tls.certificatesFile = ~/.cert/outlook.office365.com.pem;
      };
    };
    accounts.maraevme = {
      address = "vlad@maraev.me";
      realName = "Vlad Maraev";
      flavor = "gmail.com";
      imapnotify.enable = true;
      userName = "vlad@maraev.me";
      msmtp.enable = true;
      mu.enable = true;
      passwordCommand = "pass Email/vlad@maraev.me";
      imap.tls.certificatesFile = ~/.cert/outlook.office365.com.pem;
      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "both";
      };

    };
    accounts.talkamatic = {
      address = "vlad@talkamatic.se";
      realName = "Vladislav Maraev";

      imap.host = "outlook.office365.com";
      imap.tls.certificatesFile = ~/.cert/outlook.office365.com.pem;
      mbsync = {
        enable = false;
        create = "maildir";
        expunge = "both";
        extraConfig.account = {
          AuthMechs = "XOAUTH2";
        };
      };
      msmtp.enable = true;
      userName = "vlad@talkamatic.se";
      passwordCommand = "oauth2ms --config=config-2.json";
      smtp = {
        host = "smtp.office365.com";
        tls.certificatesFile = ~/.cert/outlook.office365.com.pem;
      };
    };
  };
  programs.zsh = {
    enable = true;
    syntaxHighlighting = {
      enable = true;
    };
    oh-my-zsh = {
      enable = true;
      theme = "apple";
    };
    shellAliases = {
      ll = "ls -l";
      update = "home-manager switch";
      e = "_e() { emacsclient -q $@ & }; _e";
      cleanlibrary = "nix-shell ~/Developer/imbib/shell.nix --run 'cd ~/Developer/imbib/; cabal run imbibatch -- cleanup'";
    };
    history = {
      size = 10000;
    };
    initExtra = ''
               export XDG_CONFIG_HOME=$HOME/.config
               vterm_printf() {
                   if [ -n "$TMUX" ] && ([ "''${TERM%%-*}" = "tmux" ] || [ "''${TERM%%-*}" = "screen" ]); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "''${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

source ''${HOME}/.ghcup/env
               '';
  };
}
