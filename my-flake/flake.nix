{
  description = "My first flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }:
    let 
      system = "x86_64-linux";

      # Import nixpkgs with allowUnfree = true here
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      unstablePkgs = import unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
          ];

          specialArgs = {
            inherit pkgs unstablePkgs;
          };
        };
      };

      homeConfigurations = {
        goutam = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
    };
}
