{ pkgs, lib, ... }:

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

  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;
      
      lineNumberMode = "relNumber";
      searchCase = "smart";
      hideSearchHighlight = true;

      statusline.lualine.enable = true;
      statusline.lualine.refresh.statusline = 100;

      autocomplete.blink-cmp.enable = true;

      options = {
        mouse = "a";
        shiftwidth = 0;
        tabstop = 4;
        cmdheight = 0;
      };

      telescope = {
        enable = true;
      };

      utility.motion.flash-nvim.enable = true;
      utility.surround.enable = true;
      autopairs.nvim-autopairs.enable = true;

      languages = {
        enableLSP = true;
        enableFormat = true;
        enableTreesitter = true;

        nix.enable = true;
        rust.enable = true;
      };

      visuals.cinnamon-nvim.enable = true;

    };
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
