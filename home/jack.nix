{
  pkgs,
  lib,
  ...
}: {
  home.username = "jack";
  home.homeDirectory = /Users/jack;

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_GB.UTF-8";
  };

  home.packages = with pkgs; [
    cargo-lambda
    eza
    bat
    fzf
    oh-my-posh
    sketchybar
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

      useSystemClipboard = true;
      lineNumberMode = "relNumber";
      searchCase = "smart";
      hideSearchHighlight = true;

      statusline.lualine.enable = true;
      statusline.lualine.refresh.statusline = 100;
      visuals.fidget-nvim.enable = true;

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
    };
  };

  programs.aerospace = {
    enable = true;
    userSettings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
  };

  services.jankyborders = {
    enable = true;
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
        backends.ssh.allowed-signers = "~/.ssh/allowed_signers";
      };
      git.sign-on-push = true;
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
      jjbmh = "jj bookmark move --to @";
    };

    initContent = let
      zshConfigLate = lib.mkOrder 1500 ''eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/oh-my-posh/config.toml)" '';
      zshConfig = lib.mkOrder 1000 ''zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' '';
    in
      lib.mkMerge [zshConfig zshConfigLate];

    envExtra = ''
      . "$HOME/.cargo/env"
    '';
  };

  programs.ghostty = {
    enable = true;
    package =
      if pkgs.stdenv.isDarwin
      then pkgs.nur.gigamonster.ghostty-darwin
      else pkgs.ghostty;
    settings = {
      theme = "catppuccin-mocha";
      font-family = "FiraCode Nerd Font Mono";
      font-size = 18;
      macos-titlebar-style = "hidden";
      background-opacity = 0.95;
      window-padding-x = "4, 2";
      window-padding-y = "4, 2";
    };

    themes = {
      catppuccin-mocha = {
        palette = [
          "0=#45475a"
          "1=#f38ba8"
          "2=#a6e3a1"
          "3=#f9e2af"
          "4=#89b4fa"
          "5=#f5c2e7"
          "6=#94e2d5"
          "7=#bac2de"
          "8=#585b70"
          "9=#f38ba8"
          "10=#a6e3a1"
          "11=#f9e2af"
          "12=#89b4fa"
          "13=#f5c2e7"
          "14=#94e2d5"
          "15=#a6adc8"
        ];
        background = "1e1e2e";
        foreground = "cdd6f4";
        cursor-color = "f5e0dc";
        cursor-text = "1e1e2e";
        selection-background = "353749";
        selection-foreground = "cdd6f4";
      };
    };
  };
}
