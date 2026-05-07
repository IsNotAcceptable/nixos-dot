{ inputs, pkgs, soft, stable, config, lib, ... }: 
let
  jetbrains-lib = inputs.nix-jetbrains-plugins.lib;
  
  jet-rider = jetbrains-lib.buildIdeWithPlugins pkgs "rider" [
    "com.intellij.ideolog"
    "nix-idea"
  ];
in
{
  home.packages = [ jet-rider] ++ (with soft; [
    #cmd
    kitty btop scrot ueberzug highlight disfetch jq
    psmisc playerctl gum cava
    #file Manager
    kdePackages.dolphin kdePackages.ark ripgrep rsync
    nautilus

    # network
    deluge arrpc zerotierone
    amneziawg-tools wireguard-tools

    #audio
    pavucontrol mpv mpd easyeffects ncmpcpp yt-dlp socat
    #video
    gimp-with-plugins sxiv imagemagick ffmpeg
    grim slurp swappy wl-clipboard

    heroic prismlauncher
    mangohud antimicrox goverlay xdotool
    scanmem gdb
    protonup-qt steam-run
    xwayland-satellite
    vesktop

    # customizable
    lxappearance gvfs pywal picom swaylock
    dunst swaynotificationcenter libnotify avizo
    eww waybar fuzzel rofi vicinae
    wlogout gtklock syshud
    swww swaybg nitrogen
    sxhkd cliphist

    #virt
    qemu quickemu virt-manager virt-viewer
    virtio-win virtiofsd
    spice spice-gtk spice-protocol

    wineWow64Packages.yabridge winetricks zenity

    libguestfs swtpm
    scrcpy android-tools

    fluidsynth
    #dev
    arduino-ide processing
    xournalpp bc
    polkit

    #niri custom
    xdg-utils wlsunset gnome-keyring xwayland-satellite 
    kdePackages.qtdeclarative kdePackages.qt5compat 
    kdePackages.qtmultimedia kdePackages.qtpositioning 
    kdePackages.qtquicktimeline cavif libavif
    kdePackages.qtsensors kdePackages.qttranslations
    kdePackages.qtvirtualkeyboard jemalloc libdrm
    kdePackages.kirigami kdePackages.kdialog
    kdePackages.syntax-highlighting kdePackages.qt6ct
    kdePackages.breeze-icons kdePackages.plasma-integration
    libdbusmenu-gtk3 tesseract wf-recorder upower wtype
    ydotool python314Packages.evdev python313Packages.pillow
    brightnessctl ddcutil geoclue2 swayidle swaylock blueman
    fprintd libqalculate kdePackages.qtstyleplugin-kvantum
    darkly xwayland-satellite warp
  ]);

  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "IsNotAcceptable";
        user.email = "184727191+IsNotAcceptable@users.noreply.github.com";
        core.editor = "nvim";
        color.ui = true;
        safe.directory = "/home/vibeman/.cache/nix/tarball-cache";
      };
    }; #git

    vscode = {
      enable = true;
      package = soft.vscode-fhs;

      extensions = with soft.vscode-extensions; [
        ms-dotnettools.csharp
        ms-dotnettools.csdevkit
        vscode-icons-team.vscode-icons
        zhuangtongfa.material-theme
        christian-kohler.path-intellisense
        ms-vscode.cpptools
      ];

      userSettings = {
        "editor.fontSize" = 14;
        "editor.formatOnSave" = true;
        "dotnet.server.useOmnisharp" = false;
        "csharp.experimental.roslynDevKit" = true;

        "dotnet.help.firstRunExperience" = false;
        "telemetry.telemetryLevel" = "off";
        "workbench.startupEditor" = "none";

        "dotnet.dotnetPath" = "/run/current-system/sw/bin/dotnet";
      };
    }; #vscode

    obs-studio = {
      enable = true;
      package = pkgs.obs-studio.override { cudaSupport = true; };

      plugins = with pkgs.obs-studio-plugins; [
        obs-vkcapture
        obs-gstreamer
        obs-vaapi
      ];
    }; #obs

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      dotDir = ".config/zsh";

      localVariables = {
        DOTNET_ROOT = "/run/current-system/sw/bin/dotnet";
      };

      history = {
        size = 10000;
        path = "${config.xdg.stateHome}/zsh/history";
      };

      oh-my-zsh = {
        enable = true;
        theme = "jonathan";
        plugins = [ "git" "sudo" "extract" ];
      };

      shellAliases = {
        update = "doas nixos-rebuild switch --flake /etc/nixos#empty";
      };

      initContent = ''
        disfetch
      '';

    }; #zsh

    firefox = {
      enable = true;
    };
  };
}
