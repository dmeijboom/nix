{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs }:
  let
    configuration = { ... }: {
      security.pam.services.sudo_local.touchIdAuth = true;

      nix.settings.experimental-features = "nix-command flakes";

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      system.defaults = {
        dock.autohide = true;
        finder.AppleShowAllExtensions = true;
      };

      nixpkgs.hostPlatform = "aarch64-darwin";

      # Setup .localhost resolver
      services.dnsmasq.enable = true;
      services.dnsmasq.port = 53;
      services.dnsmasq.addresses = {
        ".localhost" = "127.0.0.1";
      };
    };
  in
  {
    darwinConfigurations."Dillens-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.dmeijboom = import ./home.nix;
          };
          users.users.dmeijboom.home = "/Users/dmeijboom";
        }
      ];
    };
  };
}
