{ config, lib, pkgs, soft, stable, ... }: {
  home.username = "vibeman";
  home.homeDirectory = "/home/vibeman";
  home.stateVersion = "25.05";

  imports = [
    ./hPkgs.nix
    ./vim.nix
  ];
  
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.kde.dolphin.desktop" ];
        "application/zip" = [ "org.kde.ark.desktop" ];
        "application/x-tar" = [ "org.kde.ark.desktop" ];
        "application/x-bzip2" = [ "org.kde.ark.desktop" ];
        "application/x-gzip" = [ "org.kde.ark.desktop" ];
        "application/x-7z-compressed" = [ "org.kde.ark.desktop" ];
        "application/x-rar" = [ "org.kde.ark.desktop" ];
      };
    };
  };

  home.sessionVariables = {
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
    ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
    WINEPREFIX = "${config.xdg.dataHome}/wine";
  };
}
