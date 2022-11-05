{ config, pkgs, ... }:

let
  emacs-overlay = fetchTarball {
    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  };
  nixos = import <nixos> { };
in

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "xmarvl";
  home.homeDirectory = "/Users/xmarvl";

  home.file = {
    ".emacs" = {
      source = programs/emacs/emacs;
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
  home.stateVersion = "22.05";

  nixpkgs = {
    config.allowUnfree = true; # for things like spotify
    # overlays
    overlays = [
      (import "${emacs-overlay}")
    ];
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  home.packages = [ 
    pkgs.tree
    pkgs.git
    pkgs.git-lfs
    pkgs.nodejs pkgs.nodePackages.yarn pkgs.nodePackages.typescript-language-server
    pkgs.openssl
    pkgs.omnisharp-roslyn
    pkgs.dotnet-sdk_6
  ];

  services.emacs = {
    package = pkgs.emacs;
  };
  
  programs.fish.enable = true;
  programs.mu.enable = true;
  programs.msmtp.enable = true;
  programs.mbsync.enable = true;
  
  programs.emacs = {                              
    enable = true;
    package = pkgs.emacs;
    extraPackages = import ./emacs.nix { inherit nixos pkgs; };
    overrides = self: super: {
      semantic-theming = self.trivialBuild {
        pname = "emacs-semantic-theming";
        version = "0.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "vladmaraev";
          repo = "emacs-semantics-theming";
          rev = "a7c2740b8edd50d16631496836ab915932cb411a";
          sha256 = "13d974vfj84vav1dngy5kygj0rbcrlc9dir2cm8rvmppf3yvcfy4";
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
    };
  };

  accounts.email = {
    accounts.gu = {
      address = "vladislav.maraev@gu.se";
      imap.host = "outlook.office365.com";
      imap.tls.certificatesFile = ~/.cert/outlook.office365.com.pem;
      
      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "both";
      };
      msmtp.enable = true;
      primary = true;
      userName = "vladislav.maraev@gu.se";
      passwordCommand = "security find-internet-password -a xmarvl -w";
      smtp = {
        host = "smtp.office365.com";
        tls.certificatesFile = ~/.cert/outlook.office365.com.pem;
      };
    };
  };
}