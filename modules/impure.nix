{
  lib,
  pkgs,
  self,
  ...
}:
let
  relativePath =
    path:
    assert lib.types.path.check path;
    lib.strings.removePrefix (toString self) (toString path);
  mkImpureLink =
    path:
    let
      relative = relativePath path;
    in
    pkgs.runCommandLocal relative { } "ln -s ${lib.escapeShellArg (impureRoot + relative)} $out";
  impureRoot =
    let
      impureRoot = builtins.getEnv "IMPURE_ROOT";
    in
    if impureRoot == "" then throw "IMPURE_ROOT is not set" else impureRoot;
in
{
  _module.args.impure = { inherit mkImpureLink; };
}
