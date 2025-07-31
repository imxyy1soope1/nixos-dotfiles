{ lib, username, ... }:
{
  my.home.programs.zsh.shellAliases = {
    localproxy_on = "export http_proxy=http://192.168.128.1:7890 https_proxy=http://192.168.128.1:7890 all_proxy=socks://192.168.128.1:7890";
  };
  my = {
    sops.sshKeyFile = "/home/${username}/.ssh/id_ed25519";
    coding.all.enable = true;
    coding.editor.vscode.enable = lib.mkForce false;
    cli.misc.enable = true;
    xdg.enable = true;
    cli.media.all.enable = true;
  };
}
