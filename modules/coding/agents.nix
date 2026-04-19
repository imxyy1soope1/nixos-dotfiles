{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.coding.agents;
in
{
  options.my.coding.agents = {
    enable = lib.mkEnableOption "LLM coding agents";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
      home.packages = with pkgs.llm-agents; [
        claude-code
        opencode
      ];
    };
    my.persist = {
      homeDirs = [
        ".claude"

        ".config/opencode"
        ".local/share/opencode"
      ];
      homeFiles = [
        ".claude.json"
      ];
    };
  };
}
