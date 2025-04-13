{ lib, ... }:
{
  my.home = {
    programs.zsh = {
      shellAliases = {
        proxy_on = lib.mkForce "export http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 all_proxy=socks://127.0.0.1:7891";
      };
      sessionVariables = {
        no_proxy = "192.168.3.0/24";
      };
    };
  };
  my = {
    cmd.all.enable = true;
    coding.editor.neovim.enable = true;
    coding.misc.enable = true;
    coding.langs.lua.enable = true;
    persist = {
      enable = true;
      homeDirs = [
        "workspace"
        "Virt"

        ".ssh"
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
