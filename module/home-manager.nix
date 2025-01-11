{ homeDirectory
, username
,
}: { pkgs, config, ... }:
let
  symLink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.homeDirectory = homeDirectory;
  home.username = username;
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    go
    fzf
    eza
    ripgrep
    skate
    ghostty
  ];

  xdg.configFile = {
    nvim = {
      source = ../config/nvim;
      recursive = true;
    };
    scripts = {
      source = symLink ../config/scripts;
      target = "../.scripts/";
      recursive = true;
    };
  };

  programs = {
    bash = {
      enable = true;
      bashrcExtra = builtins.readFile ../config/bash/bashrc;
      profileExtra = builtins.readFile ../config/bash/bash_profile;
    };
    git = {
      enable = true;
      userEmail = "dillonjaap@gmail.com";
      userName = "dillon";
    };
    kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      extraConfig = builtins.readFile ../config/kitty/kitty.conf;
    };
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
    gh = {
      settings.git_protocol = "https";
      settings.editor = "nvim";
      settings.aliases = { co = "pr checkout"; pv = "pr view"; };
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
} 
