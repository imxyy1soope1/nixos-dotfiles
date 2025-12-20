{ config, lib, ... }:
let
  cfg = config.my.time;
in
{
  options.my.time = {
    enable = lib.mkEnableOption "default time settings" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = "Asia/Shanghai";
    networking.timeServers = [
      "0.cn.pool.ntp.org"
      "1.cn.pool.ntp.org"
      "2.cn.pool.ntp.org"
      "3.cn.pool.ntp.org"
    ];
  };
}
