{ lib, ... }:
{
  my = {
    cli.all.enable = true;
    cli.media.all.enable = lib.mkForce false;
    coding.editor.neovim.enable = true;
    coding.misc.enable = true;
    coding.langs.lua.enable = true;
    persist = {
      enable = true;
      homeDirs = [
        "workspace"
        "Virt"
      ];
    };
  };
}
