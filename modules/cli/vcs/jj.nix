{
  config,
  lib,
  pkgs,
  username,
  userfullname,
  useremail,
  ...
}:
let
  cfg = config.my.cli.vcs.jj;
in
{
  options.my.cli.vcs.jj = {
    enable = lib.mkEnableOption "jujutsu";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "${userfullname}";
            email = "${useremail}";
          };
          ui = {
            graph.style = "square";
            default-command = "status";
            conflict-marker-style = "snapshot";
          };
          signing = {
            backend = "ssh";
            behavior = "own";
            key = "/home/${username}/.ssh/id_ed25519";
            backends.backends.ssh.allowed-signers =
              (pkgs.writeText "allowed_signers" ''
                imxyy1soope1@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEFLUkyeaK8ZPPZdVNEmtx8zvoxi7xqS2Z6oxRBuUPO imxyy@imxyy-nix
                imxyy@imxyy.top ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEFLUkyeaK8ZPPZdVNEmtx8zvoxi7xqS2Z6oxRBuUPO imxyy@imxyy-nix
              '').outPath;
          };
        };
      };
      home.packages = [ pkgs.lazyjj ];
      programs.starship = {
        settings = {
          custom = {
            jj = {
              ignore_timeout = true;
              description = "The current jj status";
              # when = "${lib.getExe pkgs.jj-starship} detect";
              # command = "${lib.getExe pkgs.jj-starship}";
              when = true;
              command = ''
                jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
                  separate(" ",
                    " ",
                    change_id.shortest(4),
                    bookmarks,
                    "|",
                    concat(
                      if(conflict, "💥"),
                      if(divergent, "🚧"),
                      if(hidden, "👻"),
                      if(immutable, "🔒"),
                    ),
                    raw_escape_sequence("\x1b[1;32m") ++ if(empty, "(empty)"),
                    raw_escape_sequence("\x1b[1;32m") ++ coalesce(
                      truncate_end(29, description.first_line(), "…"),
                      "(no description set)",
                    ) ++ raw_escape_sequence("\x1b[0m"),
                  )
                ' || {starship module git_branch && starship module git_status}
              '';
            };
          };
          git_state.disabled = true;
          git_commit.disabled = true;
          git_metrics.disabled = true;
          git_branch.disabled = true;
          git_status.disabled = true;
        };
      };
    };
  };
}
