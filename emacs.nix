{ nixos, pkgs }:
(
  epkgs: (
    with epkgs; [
      use-package

      agda-input
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
      expand-region
      boon    
      powerline
      corfu
      csharp-mode
      eglot
      tree-sitter
      tree-sitter-langs
      mu4e-marker-icons
    ]
  )
)
