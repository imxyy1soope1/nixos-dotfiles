{
  config,
  lib,
  pkgs,
  username,
  userfullname,
  emails,
  hosts,
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
            name = userfullname;
            email = emails.default;
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
              hosts
              |> lib.mapAttrsToList (
                host: key: map (email: "${email} ${key} ${host}") (builtins.attrValues emails)
              )
              |> lib.flatten
              |> lib.concatStringsSep "\n"
              |> pkgs.writeText "allowed-signers"
              |> toString;
          };
        };
      };
      programs.jjui.enable = true;
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
