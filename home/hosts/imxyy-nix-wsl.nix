{ ... }: {
  imports = [
    ../programs/misc.nix
    ../programs/coding.nix
    ../programs/xdg.nix
    ../programs/media.nix
  ];

  programs.zsh.shellAliases = {
    localproxy_on = "export http_proxy=http://192.168.128.1:7890 https_proxy=http://192.168.128.1:7890 all_proxy=socks://192.168.128.1:7890";
  };
}
