{ nixos, pkgs }:
(
  epkgs: (
    with epkgs; [
      use-package

      agda-input
      apheleia
      auctex
      auctex-latexmk
      avy
      consult
      corfu
      citar citar-embark
      diminish
      dash
      embark embark-consult
      emojify
      json-mode
      kubernetes
      mastodon
      magit forge
      marginalia
      multiple-cursors
      nano-emacs
      openwith
      orderless
      org-contrib org-bullets org-cliplink
      persistent-soft
      pdf-tools
      semantic-theming
      swiper
      thread-folding
      typescript-mode
      unicode-fonts
      vertico
      vterm
      yaml-mode
      yasnippet
      
      nix-mode
      expand-region
      boon    
      powerline
      corfu
      csharp-mode
      # tree-sitter
      # tree-sitter-langs
      mu4e-marker-icons
      mood-line
      delight
    ]
  )
)
