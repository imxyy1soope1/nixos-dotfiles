{ ... }:
{
  my.home.programs.zsh.shellAliases = {
    localproxy_on = "export http_proxy=http://192.168.128.1:7890 https_proxy=http://192.168.128.1:7890 all_proxy=socks://192.168.128.1:7890";
  };
  my = {
    coding.all.enable = true;
    cmd.misc.enable = true;
    xdg.enable = true;
    cmd.media.all.enable = true;
    desktop.media.all.enable = true;
  };
}
