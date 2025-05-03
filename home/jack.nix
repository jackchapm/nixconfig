{ config, pkgs, ... }:

{
  home.username = "jack";
  home.homeDirectory = /Users/jack;

  home.packages = with pkgs; [
    cargo-lambda
    eza
    bat
    fzf
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;


  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "chapmanjack0777@gmail.com";
        name = "Jack Chapman";
      };
      ui.editor = "nvim";
      ui.paginate = "never";
      signing = {
        behaviour = "own";
        backend = "ssh";
        key = "/Users/jack/.ssh/id_ed25519.pub";
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Jack Chapman";
    userEmail = "chapmanjack0777@gmail.com";
    signing.format = "ssh";
    signing.key = "/Users/jack/.ssh/id_ed25519.pub";
    signing.signByDefault = true;
  };

  programs.zsh = {
    enable = true;

    shellAliases = {
      awsl = "aws sso login";
      drs = "darwin-rebuild switch --flake ~/.config/nix";
      vim = "nvim";
      cat = "bat";
      catt = "bat --style=plain --paging=never";
      ls = "eza -l --icons=auto";
      jjst = "jj st";
      jjl = "jj log";
    };

    # Order 1000 - general
    initContent = "zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'";

    envExtra = ''
      . "$HOME/.cargo/env"
      export LANG=en_GB.UTF-8
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      
    };
  };
}
