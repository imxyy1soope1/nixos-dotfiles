{ lib, username, ... }:
{
  my.home.programs.zsh.shellAliases = {
    localproxy_on = "export http_proxy=http://192.168.128.1:7890 https_proxy=http://192.168.128.1:7890 all_proxy=socks://192.168.128.1:7890";
  };
  my = {
    sops.sshKeyPath = "/home/${username}/.ssh/id_ed25519";
    coding.all.enable = true;
    coding.editor.vscode.enable = lib.mkForce false;
    cmd.misc.enable = true;
    xdg.enable = true;
    cmd.media.all.enable = true;
  };
}
