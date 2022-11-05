{ nixos, pkgs }:
(
  epkgs: (
    with epkgs; [
      use-package
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
      thread-folding
      orderless
      org-contrib org-bullets
      semantic-theming
      swiper
      typescript-mode
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
