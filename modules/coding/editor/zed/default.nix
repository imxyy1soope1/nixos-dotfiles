{
  config,
  lib,
  ...
}:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "zed-editor";
  optionPath = [
    "coding"
    "editor"
    "zed"
  ];
  extraConfig = {
    my.persist.homeDirs = [
      ".config/zed"
      ".local/share/zed"
    ];
  };
}
