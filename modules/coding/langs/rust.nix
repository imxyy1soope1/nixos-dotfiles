{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "rust";
  optionPath = [
    "coding"
    "langs"
    "rust"
  ];
  config' = {
    my.home = {
      home.packages = with pkgs; [
        (fenix.stable.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ])
        evcxr # rust repl
      ];
      home.file.".cargo/config.toml".text = ''
        [source.crates-io]
        replace-with = 'rsproxy-sparse'

        [source.rsproxy-sparse]
        registry = "sparse+https://rsproxy.cn/index/"

        [net]
        git-fetch-with-cli = true
      '';
    };
    my.persist.homeDirs = [
      ".cargo"
    ];
  };
}
