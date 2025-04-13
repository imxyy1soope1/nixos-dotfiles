{ config, lib, ... }:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "ghostty";
  optionPath = [
    "desktop"
    "terminal"
    "ghostty"
  ];
  extraConfig = {
    my.home.programs.ghostty = {
      enableBashIntegration = true;
      enableZshIntegration = true;
      installBatSyntax = true;
      settings = {
        font-size = 14;
        theme = "${./tokyonight-storm}";
      };
    };
  };
}
