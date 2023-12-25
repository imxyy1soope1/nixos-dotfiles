{username, ...}: {
  wsl.enable = true;
  wsl.defaultUser = "${username}";
}
