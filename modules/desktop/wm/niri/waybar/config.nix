_: {
  layer = "top";
  position = "top";
  mod = "dock";
  exclusive = true;
  passthrough = false;
  gtk-layer-shell = true;
  height = 0;

  modules-left = [
    "clock"
    "cpu"
    "memory"
    "niri/workspaces"
  ];
  modules-center = [
    "mpris"
  ];
  modules-right = [
    "custom/notification"
    "tray"
    "wireplumber"
    "wireplumber#source"
  ];

  "niri/workspaces" = {
    format = "{value}";
  };
  cpu = {
    interval = 1;
    format = "󰞱 {}%";
    max-length = 10;
    on-click = "";
  };
  memory = {
    interval = 10;
    format = " {used:0.1f}G";
    max-length = 10;
  };
  "custom/notification" = {
    tooltip = false;
    format = "{icon}";
    format-icons = {
      notification = "<span foreground='red'><sup></sup></span>";
      none = "";
      dnd-notification = "<span foreground='red'><sup></sup></span>";
      dnd-none = "";
      inhibited-notification = "<span foreground='red'><sup></sup></span>";
      inhibited-none = "";
      dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
      dnd-inhibited-none = "";
    };
    return-type = "json";
    exec-if = "which swaync-client";
    exec = "swaync-client -swb";
    on-double-click = "swaync-client -t -sw";
    on-click-right = "swaync-client -d -sw";
    escape = true;
  };
  tray = {
    icon-size = 13;
    tooltip = false;
    spacing = 10;
  };
  mpris = {
    player = "musicfox";
    interval = 1;
    format = "{status_icon} {artist} - {title}";
    max-length = 60;
    status-icons = {
      paused = "";
      playing = "";
      stopped = "";
    };
    tooltip = false;
    on-scroll-up = "playerctl -p musicfox volume 0.05+";
    on-scroll-down = "playerctl -p musicfox volume 0.05-";
  };
  clock = {
    format = " {:%H:%M   %m.%d}";
    tooltip = false;
  };
  wireplumber = {
    format = "{icon} {volume}%";
    tooltip = false;
    format-muted = "󰟎 Muted";
    on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
    on-click-middle = "pwvucontrol";
    scroll-step = 5;
    format-icons = {
      headphone = "󰋋";
      hands-free = "󰋋";
      headset = "󰋋";
      phone = "";
      portable = "";
      car = "";
      default = [
        ""
        ""
        ""
      ];
    };
  };
  "wireplumber#source" = {
    node-type = "Audio/Source";
    format = "󰍬 {volume}%";
    tooltip = false;
    format-muted = "󰍬 Muted";
    on-click = "wpctl set-mute @DEFAULT_SOURCE@ toggle";
    on-click-middle = "pwvucontrol";
    scroll-step = 5;
  };
}
