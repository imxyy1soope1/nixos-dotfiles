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
    my.hm = {
      home.packages = with pkgs; [
        (fenix.stable.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
          "rust-analyzer"
        ])
        evcxr # rust repl

        pest-ide-tools
      ];
      home.file.".cargo/config.toml".text = ''
        [source.crates-io]
        replace-with = 'rsproxy-sparse'

        [source.rsproxy-sparse]
        registry = "sparse+https://rsproxy.cn/index/"

        [net]
        git-fetch-with-cli = true
      '';
      programs.zsh.initContent = lib.mkAfter ''
        export PATH=$PATH:$HOME/.cargo/bin
      '';
    };
    my.persist.homeDirs = [
      ".cargo"
    ];
  };
}
