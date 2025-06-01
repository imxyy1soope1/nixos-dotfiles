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

        {
          directory = ".ssh";
          mode = "0700";
        }
        ".local/state"
        ".local/share"
        ".local/share/nvim"
        ".cache"

        ".ollama"
      ];
      nixosDirs = [
        "/etc/ssh"
      ];
    };
  };
}
