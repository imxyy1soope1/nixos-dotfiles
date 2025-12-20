{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.my.audio;
in
{
  options.my.audio = {
    enable = lib.mkEnableOption "default audio settings";
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      audio.enable = true;
    };
    users.extraUsers.${username}.extraGroups = [ "audio" ];
    my.persist.homeDirs = [ ".local/state/wireplumber" ];
    my.hm.home.packages = [ pkgs.pwvucontrol ];
  };
}
