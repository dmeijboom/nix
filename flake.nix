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
      config = {
        nixpkgs.config.allowUnfree = true;
        nix.settings = {
          experimental-features = "nix-command flakes pipe-operators";
          extra-substituters = "https://devenv.cachix.org";
          extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
        };
      };
      home-config = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.dmeijboom = import ./home.nix;
      };
    in
    {
      nixosConfigurations."dillen-linux" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          config
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = home-config;
            users.users.dmeijboom.home = "/home/dmeijboom";
          }
        ];
      };
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
            home-manager = home-config;
            users.users.dmeijboom.home = "/Users/dmeijboom";
          }
        ];
      };
    };
}
