{
  lib,
  pkgs,
  self,
  username,
  ...
}:
let
  stateDir = "/home/${username}/.local/state/dotfiles";

  relativePath =
    path:
    assert lib.types.path.check path;
    lib.strings.removePrefix (toString self) (toString path);

  mkLiveLink =
    path:
    let
      relative = relativePath path;
    in
    pkgs.runCommandLocal relative { } "ln -s ${lib.escapeShellArg (stateDir + relative)} $out";
in
{
  config = {
    _module.args.live = { inherit mkLiveLink; };
  };
}
