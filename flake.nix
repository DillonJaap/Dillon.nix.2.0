{
  description = "Example kickstart Home Manager environment.";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";

  };

  outputs =
    inputs @ { self
    , flake-parts
    , home-manager
    , nixpkgs
    , darwin
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem =
        { config
        , self'
        , inputs'
        , pkgs
        , system
        , ...
        }: { };
      flake = {
        homeConfigurations =
          let
            homeManagerModule = import ./module/home-manager.nix {
              homeDirectory = "/home/djaap";
              username = "djaap";
            };
            homeManager = system:
              home-manager.lib.homeManagerConfiguration {
                modules = [ homeManagerModule ];
                pkgs = import nixpkgs { system = "x86_64-linux"; config.android_sdk.accept_license = true; config.allowUnfree = true; };
                #pkgs = nixpkgs.legacyPackages.${system};
              };
            darwinManagerModule = import ./system/hhome-manager.nix {
              username = "DJaap";
              homeDirectory = "/home/DJaap";
            };
            darwinManager =
              inputs.darwin.lib.darwinSystem {
                system = "aarch64-darwin";
                modules = [
                  {
                    services.nix-daemon.enable = true;
                    users.users.DJaap.home = "/Users/DJaap";
                  }
                  #system-config

                  inputs.home-manager.darwinModules.home-manager
                  {
                    # add home-manager settings here
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users."DJaap" = darwinManagerModule;
                  }
                  # add more nix modules here
                ];
                pkgs = import nixpkgs { system = "aarch-darwin"; config.allowUnfree = true; };
              };

          in
          {
            aarch64-darwin = darwinManager "aarch64-darwin";
            x86_64-darwin = darwinManager "x86_64-darwin";
            aarch64-linux = homeManager "aarch64-linux";
            x86_64-linux = homeManager "x86_64-linux";
          };
      };
    };
}
