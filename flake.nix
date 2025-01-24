{
  description = "Example kickstart Nix on macOS environment.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, darwin, home-manager, nixpkgs, ... }:
    let
      darwin-system = import ./system/darwin.nix {
        inherit inputs;
        username = "DJaap";
      };
      #linux-system = import ./system/nixos.nix {
      #inherit inputs;
      #username = "dillon";
      #password = "temppass";
      #};
    in
    {
      darwinConfigurations = {
        aarch64 = darwin-system "aarch64-darwin";
        x86_64 = darwin-system "x86_64-darwin";
      };
      #nixosConfigurations = {
      #aarch64 = linux-system "aarch64-linux";
      #x86_64 = linux-system "x86_64-linux";
      #};
    };
}
