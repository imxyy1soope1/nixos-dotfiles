{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  default = true;
  optionName = "default fish settings";
  optionPath = [
    "cli"
    "shell"
    "fish"
  ];
  config' = {
    my.persist.homeDirs = [
      ".local/share/fish"
    ];
    my.hm = {
      programs.fish = {
        enable = true;
        plugins = [
          {
            name = "extract";
            src = pkgs.fetchFromGitHub {
              owner = "hexclover";
              repo = "fish-extract-ng";
              tag = "v0.1";
              hash = "sha256-yef5NX4HdZ3ab/2AzNrvvhi0CbeTvXYKZmyH76gIpyk=";
            };
          }
        ];
        shellAliases = {
          la = "lsd -lah";
          ls = "lsd";
          svim = "sudoedit";
          nf = "fastfetch";
          tmux = "tmux -T RGB,focus,overline,mouse,clipboard,usstyle";
        };
        interactiveShellInit = ''
          fish_vi_key_bindings
          source ${
            builtins.fetchurl {
              url = "https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/tags/v4.14.1/extras/fish/tokyonight_storm.fish";
              sha256 = "0a2pg78k8cv0hx8p02lxnb7giblwn7z9hnb6i6mdx4w5lg4wfg40";
            }
          }
        '';
        functions = {
          fish_greeting = "";
        };
      };
    };
  };
}
