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
        codex
        claude-code
        # opencode
        pi
        omp
      ];
    };
    my.persist = {
      homeDirs = [
        ".agents"

        ".claude"

        # ".config/opencode"
        # ".local/share/opencode"

        ".codex"

        ".pi"
        ".omp"
      ];
      homeFiles = [
        ".claude.json"
      ];
    };
  };
}
