{ inputs, ... }: {
  imports = [
    ../programs
  ];

  nixpkgs.overlays = [
    inputs.dwm-local.overlays.default
  ];

  programs.zsh = {
    shellAliases = {
      localproxy_on = "export http_proxy=http://192.168.3.115:7890 https_proxy=http://192.168.3.115:7890 all_proxy=socks://192.168.3.115:7890";
    };
    sessionVariables = {
      no_proxy = "192.168.3.0/24";
    };
    profileExtra = ''
      if [ `tty` = "/dev/tty1" -a $XDG_RUNTIME_DIR ]; then
          echo 'Starting Hyprland...'
          exec Hyprland &> /dev/null
      elif [ `tty` = "/dev/tty6" ]; then
          clear
      fi
    '';
  };
}
