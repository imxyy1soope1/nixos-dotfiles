{ ... }:
{
  my = {
    cli.all.enable = true;
    coding.editor.neovim.enable = true;
    coding.misc.enable = true;
    coding.langs.lua.enable = true;
    coding.langs.rust.enable = true;
    persist = {
      enable = true;
      homeDirs = [
        "workspace"
        "Virt"

        ".local/state"
        ".cache"

        ".ollama"
      ];
    };
  };
}
