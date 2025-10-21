{
  description = "Example kickstart Nix on macOS environment.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    };
  };

  outputs = inputs@{ self, darwin, home-manager, nixpkgs, ... }:
  let
  darwin-system = import ./system/darwin.nix {
    inherit inputs;
    username = "DJaap";
  };
  linux-system = import ./system/linux.nix {
    inherit inputs;
    username = "dillon";
  };
  in
  {
    darwinConfigurations = {
      aarch64 = darwin-system "aarch64-darwin";
      x86_64 = darwin-system "x86_64-darwin";
    };
    homeConfigurations = {
#aarch64 = linux-system "aarch64-linux";
      x86_64 = linux-system "x86_64-linux";
    };
  };
}
