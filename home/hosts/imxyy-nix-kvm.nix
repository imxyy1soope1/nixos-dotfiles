{ ... }: {
  imports = [
    ../programs/misc.nix
    ../programs/coding.nix
  ];

  programs.zsh = {
    shellAliases = {
      localproxy_on = "export http_proxy=http://192.168.3.115:7890 https_proxy=http://192.168.3.115:7890 all_proxy=socks://192.168.3.115:7890";
    };
    sessionVariables = {
      no_proxy = "192.168.3.0/24";
    };
  };
}
