with import ./constants.nix;
{
  systems = with arch; [
    x86_64.linux
    i686.linux
  ];
  hosts = [
    "${hostprefix}"
    "${hostprefix}-kvm"
    "${hostprefix}-wsl"
  ];
}
