{ nixos, pkgs }:
(
  epkgs: (
    with epkgs; [
      use-package

      agda-input
      consult
      corfu
      citar
      diminish
      dash
      embark embark-consult
      emojify
      magit forge
      marginalia
      multiple-cursors
      openwith
      orderless
      org-contrib org-bullets
      persistent-soft
      semantic-theming
      swiper
      thread-folding
      typescript-mode
      unicode-fonts
      vertico
      
      nix-mode
      avy
      expand-region
      boon    
      powerline
      corfu
      auctex
      auctex-latexmk
      csharp-mode
      eglot
      tree-sitter
      tree-sitter-langs
      mu4e-marker-icons
    ]
  )
)
