{
  config,
  lib,
  pkgs,
  userfullname,
  useremail,
  ...
}:
lib.my.makeHomeProgramConfig {
  inherit config;
  programName = "jujutsu";
  optionPath = [
    "cli"
    "vcs"
    "jj"
  ];
  extraConfig = {
    my.home = {
      programs.jujutsu = {
        settings = {
          user = {
            name = "${userfullname}";
            email = "${useremail}";
          };
          ui = {
            graph.style = "square";
            default-command = "status";
          };
        };
      };
      /* programs.zsh.initContent = lib.mkAfter ''
        fpath+=${
          pkgs.fetchFromGitHub {
            owner = "rkh";
            repo = "zsh-jj";
            rev = "b6453d6ff5d233d472e5088d066c6469eb05c71b";
            hash = "sha256-GDHTp53uHAcyVG+YI3Q7PI8K8M3d3i2+C52zxnKbSmw=";
          }
        }/functions
        zstyle ':vcs_info:*' enable jj
      ''; */
      home.packages = [ pkgs.lazyjj ];
    };
  };
}
