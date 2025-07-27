{
  config,
  lib,
  username,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  default = true;
  optionName = "default audio settings";
  optionPath = [ "audio" ];
  config' = {
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
  };
}
