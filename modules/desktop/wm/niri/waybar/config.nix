{ ... }:
{
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
    "pulseaudio"
    "pulseaudio#microphone"
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
    toottip-format = "{status_icon} Musicfox {artist} - {album} - {title}";
    on-scroll-up = "playerctl -p musicfox volume 0.05+";
    on-scroll-down = "playerctl -p musicfox volume 0.05-";
  };
  clock = {
    format = " {:%H:%M   %m.%d}";
    tooltip = false;
  };
  pulseaudio = {
    format = "{icon} {volume}%";
    tooltip = false;
    format-muted = "󰟎 Muted";
    on-click = "pamixer -t";
    on-click-middle = "pavucontrol & disown";
    on-scroll-up = "pamixer -i 5";
    on-scroll-down = "pamixer -d 5";
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
  "pulseaudio#microphone" = {
    format = "{format_source}";
    tooltip = false;
    format-source = "󰍬 {volume}%";
    format-source-muted = "󰍭 Muted";
    on-click = "pamixer --default-source -t";
    on-scroll-up = "pamixer --default-source -i 5";
    on-scroll-down = "pamixer --default-source -d 5";
    scroll-step = 5;
  };
}
