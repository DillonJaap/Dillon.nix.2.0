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
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    go
    cargo
    fzf
    eza
    ripgrep
    skate
    #    nerdfonts
    luarocks
    php
    (lib.recursiveUpdate php83Packages.composer { meta.priority = php83Packages.composer.meta.priority or 0 - 1; })
    ocaml
    flutter
    cmake
    clang
    glibc
    glib
    libclang
    android-studio
    pkg-config
    gtk3
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
