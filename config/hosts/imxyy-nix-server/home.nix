{ lib, ... }:
{
  my = {
    cli.all.enable = true;
    cli.media.all.enable = lib.mkForce false;
    coding.editor.neovim.enable = true;
    coding.misc.enable = true;
    coding.langs.lua.enable = true;
    coding.langs.rust.enable = true;
    fonts.enable = lib.mkForce false;
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
