rec {
  username = "imxyy";
  userfullname = "imxyy_soope_";
  userdesc = userfullname;
  useremail = "imxyy1soope1@gmail.com";
  arch = {
    aarch64 = {
      linux = "aarch64-linux";
      darwin = "aarch64-darwin";
    };
    i686 = {
      linux = "i686-linux";
    };
    x86_64 = {
      linux = "x86_64-linux";
      darwin = "x86_64-darwin";
    };
  };
  hosts =
    with arch;
    let
      hostprefix = "imxyy-nix";
    in
    [
      {
        hostname = hostprefix;
        system = x86_64.linux;
      }
      {
        hostname = "${hostprefix}-server";
        system = x86_64.linux;
      }
      {
        hostname = "${hostprefix}-wsl";
        system = x86_64.linux;
      }
    ];
}
