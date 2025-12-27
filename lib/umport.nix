# This function is modified from:
# https://github.com/yunfachi/nypkgs/blob/master/lib/umport.nix
#
# !!! REMOVING THIS NOTICE VIOLATES THE MIT LICENSE OF THE UMPORT PROJECT !!!
# This notice must be retained in all copies of this function, including modified versions!
# The MIT License can be found here:
# https://github.com/yunfachi/nypkgs/blob/master/LICENSE
{ lib, ... }:
let
  umport =
    {
      path ? null,
      paths ? [ ],
      include ? [ ],
      exclude ? [ ],
      extraExcludePredicate ? _: true,
      recursive ? true,
    }:
    with lib;
    with fileset;
    let
      excludedFiles = filter (path: pathIsRegularFile path) exclude;
      excludedDirs = filter (path: pathIsDirectory path) exclude;
      isExcluded =
        path:
        (elem path excludedFiles)
        || ((filter (excludedDir: lib.path.hasPrefix excludedDir path) excludedDirs) != [ ])
        || extraExcludePredicate path;
    in
    unique (
      (filter (file: pathIsRegularFile file && hasSuffix ".nix" (toString file) && !isExcluded file) (
        concatMap (
          path:
          if recursive then
            toList path
          else
            mapAttrsToList (
              name: type: path + (if type == "directory" then "/${name}/default.nix" else "/${name}")
            ) (builtins.readDir path)
        ) (unique (if path == null then paths else [ path ] ++ paths))
      ))
      ++ (if recursive then concatMap (path: toList path) (unique include) else unique include)
    );
in
umport
