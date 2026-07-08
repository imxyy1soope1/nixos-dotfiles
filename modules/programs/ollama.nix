{
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.ollama;
in
{
  options.my.programs.ollama = {
    enable = lib.mkEnableOption "ollama";
  };

  config = lib.mkIf cfg.enable {
    my.hm.services.ollama.enable = true;
    my.persist.homeDirs = [
      ".ollama"
    ];
  };
}
