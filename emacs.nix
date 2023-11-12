{ pkgs }:
(
  epkgs: (
    with epkgs; [
      use-package
      agda-input
      apheleia
      auctex
      auctex-latexmk
      avy
      chatgpt-shell
      consult
      corfu
      citar citar-embark
      diminish
      dante
      dash
      embark embark-consult
      emojify
      exec-path-from-shell
      gnuplot
      haskell-mode
      json-mode
      kubernetes
      ledger-mode
      mastodon
      magit forge
      marginalia
      multiple-cursors
      mu4e-alert
      openwith
      orderless
      org-contrib org-bullets org-cliplink org-drill
      password-store
      persistent-soft
      pdf-tools
      semantic-theming
      swiper
      thread-folding
      tree-sitter-langs
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
      treesit-grammars.with-all-grammars
      # tree-sitter-langs-bugfix
      mu4e-marker-icons
      # mood-line
      delight
    ]
  )
)
