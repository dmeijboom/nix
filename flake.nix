{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zjstatus.url = "github:dj95/zjstatus";
    zjstatus.inputs.nixpkgs.follows = "nixpkgs";
    helix.url = "github:dmeijboom/helix";
    helix.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    worktrunk.url = "github:max-sixty/worktrunk";
    worktrunk.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      worktrunk,
      ...
    }:
    let
      customOverlay = import ./overlays { inherit inputs; };

      # Overlay that disables some checks for packages we hit issues with.
      checksOverlay = final: prev: {
        direnv = prev.direnv.overrideAttrs (_: { doCheck = false; });
      };

      overlays = [
        checksOverlay
        customOverlay
      ];

      mkPkgs =
        system:
        import nixpkgs {
          inherit system overlays;
          config = {
            allowUnfree = true;
            doCheckByDefault = false;
          };
        };

      # nix-darwin / NixOS-style module that mirrors mkPkgs settings, used by
      # the darwinConfiguration below.
      nixpkgsModule = {
        nixpkgs.config = {
          allowUnfree = true;
          doCheckByDefault = false;
        };
        nixpkgs.overlays = overlays;
        nix.settings = {
          experimental-features = "nix-command flakes pipe-operators";
          extra-substituters = "https://devenv.cachix.org";
          extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
        };
      };

      mkHome =
        system: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          modules = [
            ./home.nix
            worktrunk.homeModules.default
          ] ++ modules;
        };
    in
    {
      darwinConfigurations."Dillens-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          nixpkgsModule
          {
            security.pam.services.sudo_local.touchIdAuth = true;
            system.configurationRevision = self.rev or self.dirtyRev or null;
            system.stateVersion = 6;
            nixpkgs.hostPlatform = "aarch64-darwin";

            # Setup .localhost resolver
            services.dnsmasq.enable = true;
            services.dnsmasq.port = 53;
            services.dnsmasq.addresses = {
              ".localhost" = "127.0.0.1";
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.dmeijboom = {
                imports = [
                  ./home.nix
                  worktrunk.homeModules.default
                ];
                custom.cloud.enable = true;
              };
            };
            users.users.dmeijboom.home = "/Users/dmeijboom";
          }
        ];
      };
      homeConfigurations = {
        kpn = mkHome "x86_64-linux" [
          {
            custom.username = "so";
            custom.cloud.enable = true;
          }
        ];
      };
    };
}
