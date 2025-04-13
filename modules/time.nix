{ config, lib, ... }:
lib.my.makeSwitch {
  inherit config;
  default = true;
  optionName = "default time settings";
  optionPath = [ "time" ];
  config' = {
    time.timeZone = "Asia/Shanghai";
    networking.timeServers = [
      "0.cn.pool.ntp.org"
      "1.cn.pool.ntp.org"
      "2.cn.pool.ntp.org"
      "3.cn.pool.ntp.org"
    ];
  };
}
