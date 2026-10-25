{ config, lib, pkgs, ... }: {
  home.username = "ina";
  home.homeDirectory = "/home/ina";
  home.stateVersion = "26.05";

  imports = [
    ./hPkgs.nix
  ];
  
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    mimeApps = {
      enable = true;
    };
  };

  home.shellAliases = {
    e-pentest = "nix develop ~/CONTAINERS/pentest";
    e-office = "nix develop ~/CONTAINERS/office";
  };

  home.sessionVariables = {
    QML2_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
    ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
    WINEPREFIX = "${config.xdg.dataHome}/wine";
    EDITOR = "nvim"; VISUAL = "nvim";
  };

}
