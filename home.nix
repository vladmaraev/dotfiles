{ config, pkgs, stdenv,  ... }:

let
  emacs-overlay = fetchTarball {
    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  };
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
  home.stateVersion = "22.11";
  manual.manpages.enable = false;

  nixpkgs = {
    config.allowUnfree = true; # for things like spotify
    # overlays
    overlays = [
      (import "${emacs-overlay}")
    ];
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  home.packages = let
    agda-stuff = (pkgs.agda.withPackages (with pkgs; [
      agdaPackages.standard-library
    ]));
    python-packages = py-pkgs: with py-pkgs; [
      nltk
      #  pytorch
        # numpy
        # pandas
        # pygments
        # scikit-learn
        # tensorflowWithoutCuda
    ];
    python-stuff = pkgs.python38.withPackages python-packages;
    tex = (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic
        adjustbox
        algorithm2e
        acmart
        biber
        biblatex
		    biblatex-apa
        boondox
        catchfile
        collection-fontsrecommended
        collectbox
        comment
        csquotes
        cleveref
        datatool
        doublestroke
        ebproof
        environ
        enumitem
			  eqparbox
        fontaxes
        framed
        fvextra
        glossaries
        glossaries-english
        harvard
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
        prftree
        pst-tree
        pst-node
        pstricks
        relsize
        siunitx
        sectsty
        scheme-small wrapfig marvosym wasysym
        soul
        stmaryrd
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
      aspell
      aspellDicts.en
      dotnet-sdk_6
      git-lfs
      imagemagick
      nodejs nodePackages.yarn nodePackages.prettier nodePackages.typescript nodePackages.typescript-language-server nodePackages.sass
      openssl
      omnisharp-roslyn
      pass
      passff-host
      # python-stuff
      terminal-notifier
      tex
      tree
      iterm2
      ffmpeg
    ];

  programs.git = {
    enable = true;
    userEmail = "vlad@maraev.me";
    userName = "Vladislav Maraev";
    signing = {
        key = "0A6A67D83FBD77DB";
        signByDefault = true;
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
    package = pkgs.emacsGit;
    extraPackages = import ./emacs.nix { inherit nixos pkgs; };
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
    accounts.talkamatic = {
      address = "vlad@talkamatic.se";
      realName = "Vladislav Maraev";

      imap.host = "outlook.office365.com";
      imap.tls.certificatesFile = ~/.cert/outlook.office365.com.pem;
      mbsync = {
        enable = true;
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
    enableSyntaxHighlighting = true;
    
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


               '';
  };
}
