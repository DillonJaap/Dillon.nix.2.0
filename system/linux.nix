{ inputs, username }: 
let
  home-manager-config = import ../module/home-manager.nix;
in
inputs.home-manager.lib.homeManagerConfiguration {
  # Specify the target user
  username = username;

  # Specify the target host system (Linux)
  pkgs = inputs.nixpkgs.pkgs;

  # Define Home Manager configuration
  modules = [
    {
      # Home Manager global settings
      home.stateVersion = "24.05"; # Set based on Home Manager version compatibility

      # User-specific configuration
      home.username = username;
      home.homeDirectory = "/home/${username}";

    }

    # Import additional Home Manager configurations
    home-manager-config
  ];
}
