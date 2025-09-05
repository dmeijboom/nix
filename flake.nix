{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
      config = {
        nixpkgs.config.allowUnfree = true;
        nix.settings = {
          experimental-features = "nix-command flakes pipe-operators";
          extra-substituters = "https://devenv.cachix.org";
          extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
        };
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
              users.dmeijboom = {
                imports = [ ./home.nix ];
                custom.cloud.enable = true;
              };
            };
            users.users.dmeijboom.home = "/Users/dmeijboom";
          }
        ];
      };
      homeConfigurations =
        forAllSystems (
          system:
          home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [ ./home.nix ];
          }
        )
        // {
          kpn = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              { nixpkgs.config.allowUnfree = true; }
              ./home.nix
              {
                custom.username = "so";
                custom.cloud.enable = true;
              }
            ];
          };
        };
    };
}
