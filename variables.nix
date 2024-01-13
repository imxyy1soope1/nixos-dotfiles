with import ./constants.nix;
{
  systems = with arch; [
    x86_64.linux
    i686.linux
  ];
  hosts = with arch; [
    {
      hostname = "${hostprefix}";
      system = x86_64.linux;
    }
    {
      hostname = "${hostprefix}-kvm";
      system = x86_64.linux;
    }
    {
      hostname = "${hostprefix}-wsl";
      system = x86_64.linux;
    }
  ];
}
