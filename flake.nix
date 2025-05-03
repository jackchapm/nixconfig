{
  description = "jackbook nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    gigamonster.url = "github:gigamonster256/nur-packages";
    gigamonster.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, gigamonster, ... }:
  let
    gigamonsterOverlay = final: prev: {
      nur = (prev.nur or {}) // {
        gigamonster = inputs.gigamonster.packages.${prev.system};
      };
    };

    configuration = { pkgs, ... }: {
      users.users.jack.home = /Users/jack;
      

      environment.systemPackages =
        [
            pkgs.neovim
            pkgs.gnupg
            pkgs.gradle
            pkgs.kotlin
            pkgs.fastfetch
            pkgs.wget
            pkgs.bun
        ];

      homebrew = {
        enable = true;

        casks = [
          "docker"
          "scroll-reverser"
        ];

        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };
      
      environment.pathsToLink = [ "/share/zsh" ];

      nix.settings.experimental-features = "nix-command flakes";
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."jackbook" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        # todo: better solution for this?
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ gigamonsterOverlay ];
        })
        configuration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jack = ./home/jack.nix;
        }
      ];
    };
  };
}
