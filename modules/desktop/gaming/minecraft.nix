{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "minecraft";
  optionPath = [
    "desktop"
    "gaming"
    "minecraft"
  ];
  config' = {
    my.home.home.packages = [
      (pkgs.hmcl.overrideAttrs {
        postFixup = ''
          substituteInPlace $out/share/applications/HMCL.desktop --replace-fail 'Exec=hmcl' 'Exec=sh -c "cd ~/.local/share/hmcl; hmcl"'
        '';
      })
    ];

    my.persist.homeDirs = [
      ".minecraft"
      ".local/share/hmcl"
    ];
  };
}
