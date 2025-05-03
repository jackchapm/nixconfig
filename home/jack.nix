{ config, pkgs, lib, ... }:

{
  home.username = "jack";
  home.homeDirectory = /Users/jack;

  home.packages = with pkgs; [
    cargo-lambda
    eza
    bat
    fzf
    oh-my-posh
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    configFile."oh-my-posh/config.toml".source = ./oh-my-posh.toml;
  };


  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "chapmanjack0777@gmail.com";
        name = "Jack Chapman";
      };
      ui = {
        editor = "nvim";
        paginate = "never";
        show-cryptographic-signatures = true;
      };
      signing = {
        behavior = "drop";
        backend = "ssh";
        key = "~/.ssh/id_ed25519.pub";
      };
      git.sign-on-push = true;
      backends.ssh.allowed-signers = "~/.ssh/allowed_signers";
    };
  };

  programs.git = {
    enable = true;
    userName = "Jack Chapman";
    userEmail = "chapmanjack0777@gmail.com";
    signing.format = "ssh";
    signing.key = "~/.ssh/id_ed25519.pub";
    signing.signByDefault = true;
    extraConfig = {
      core.autocrlf = false;
      pull.rebase = true;
    };
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
    initExtra = "zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'";

    initContent = 
    lib.mkOrder 1500 ''
      eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/oh-my-posh/config.toml)"
    '';

    envExtra = ''
      . "$HOME/.cargo/env"
      export LANG=en_GB.UTF-8
    '';
  };

  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.nur.gigamonster.ghostty-darwin else pkgs.ghostty;
    settings = {
      macos-titlebar-style = "hidden";
    };
  };
}
