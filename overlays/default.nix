{
  lib,
  ...
}:
{
  flake.overlays = {
    modifications =
      final: prev:
      lib.infuse prev {
        cage.__output.patches.__append = [ ./cage-specify-output-name.patch ];
        bottles.__input.removeWarningPopup.__assign = true;

        easytier.__assign = final.stable.easytier;

        python314Packages.patool.__input.file.__output.postPatch.__append =
          lib.warn "Remove `file` patch once https://github.com/NixOS/nixpkgs/pull/540742 is merged" ''
            substituteInPlace src/landlock.c --replace-fail \
              "LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_READ_DIR" \
              "LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_READ_DIR | LANDLOCK_ACCESS_FS_EXECUTE"
          '';

        mautrix-telegram.__input.python3.__input.packageOverrides.__assign = _pyfinal: pyprev: {
          telethon = pyprev.telethon.overridePythonAttrs {
            disabled = false;
          };
        };
        mautrix-telegram.__output.patches.__append = [ ./mautrix-telegram-use-importlib-resources.patch ];
      };
  };
}
