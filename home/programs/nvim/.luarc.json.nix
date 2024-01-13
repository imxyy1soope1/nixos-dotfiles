{ config, ... }:
let
  neovim-pkg = config.programs.neovim.package;
  nvimdata = "${config.xdg.dataHome}/nvim";
  nvimconf = "${config.xdg.configHome}/nvim";
  luarc = {
    "workspace.library" = [
      "${nvimconf}"
      "${nvimdata}/lazy/**"
      "${neovim-pkg}/share/nvim/runtime/**"
      "${neovim-pkg}/lib/nvim"
      "\${3rd}/luv/library"
      "\${3rd}/luassert/library"
    ];
    "workspace.checkThirdParty" = false;
  };
in
{
  config = {
    xdg.configFile."nvim/.luarc.json".text = builtins.toJSON luarc;
  };
}
