{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zjstatus.url = "github:dj95/zjstatus";
    zjstatus.inputs.nixpkgs.follows = "nixpkgs";
    helix.url = "github:helix-editor/helix/master";
    helix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      zjstatus,
      helix,
    }:
    let
      config = {
        nixpkgs.config = {
          allowUnfree = true;
          doCheckByDefault = false;
        };
        nixpkgs.overlays = [
          (final: prev: {
            direnv = prev.direnv.overrideAttrs (_: {
              doCheck = false;
            });
          })
        ];
        nix.settings = {
          experimental-features = "nix-command flakes pipe-operators";
          extra-substituters = "https://devenv.cachix.org";
          extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
        };
      };

      mkHome =
        system: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.doCheckByDefault = false;
            overlays = [
              (final: prev: {
                direnv = prev.direnv.overrideAttrs (_: {
                  doCheck = false;
                });
              })
            ];
          };
          extraSpecialArgs = {
            zjstatus = zjstatus.packages.${system}.default;
            helix-pkg = helix.packages.${system}.default;
          };
          modules = [ ./home.nix ] ++ modules;
        };
    in
    {
      darwinConfigurations."Dillens-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          config
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
              extraSpecialArgs = {
                zjstatus = zjstatus.packages.aarch64-darwin.default;
                helix-pkg = helix.packages.aarch64-darwin.default;
              };
              users.dmeijboom = {
                imports = [ ./home.nix ];
                custom.cloud.enable = true;
              };
            };
            users.users.dmeijboom.home = "/Users/dmeijboom";
          }
        ];
      };
      homeConfigurations = {
        server = mkHome "x86_64-linux" [
          { custom.mode = "server"; }
        ];
        kpn = mkHome "x86_64-linux" [
          {
            custom.username = "so";
            custom.cloud.enable = true;
          }
        ];
      };
    };
}
