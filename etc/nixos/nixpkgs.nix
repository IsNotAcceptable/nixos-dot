{ config, pkgs, lib, inputs, ...}: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim git btop cava yazi fastfetch
    upower wlsunset brightnessctl
    bluetui bluez-tools playerctl
    pavucontrol

    kitty
    
    waybar wofi quickshell swaylock matugen swaynotificationcenter
    libnotify
    (writeScriptBin "nix-session-run" (builtins.readFile ./scripts/nix-session-run.sh))
    (writeScriptBin "wofi-nix" (builtins.readFile ./scripts/wofi-nix.sh))
    qt6.qtmultimedia kdePackages.syntax-highlighting qt5.qtgraphicaleffects
    qt6.qt5compat

    amneziawg-tools

    gcc gnumake nodejs jq

    fuse3
  ];

  environment.etc."nix-session-hook.sh".source = ./scripts/nix-session-hook.sh;

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
    font-awesome
    twemoji-color-font
    material-symbols material-design-icons
  ];

  programs = {
    zsh.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = stable: with pkgs; [
          libpng libpng12
          libepoxy pcre2
          double-conversion
        ];
      };
    }; #appimage

    steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
      protontricks = {
        enable = true;
      };
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [
        libgdiplus
        openssl
        libxcursor libxi libxinerama libxscrnsaver
        libpng libpulseaudio libvorbis stdenv.cc.cc.lib vulkan-loader
      ];
    }; #steam
    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 10;
        };
        
        #gpu = {
        #  apply_gpu_optimisations = "accept-responsibility";
        #  gpu_vendor = "nvidia";
        #  nv_powermode_rw = 1;
        #};
      };
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    }; #steam

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        kdePackages.qtbase kdePackages.qttools kdePackages.qtwayland
        kdePackages.qtsvg kdePackages.qtimageformats

        util-linux stdenv.cc.cc
        zlib zstd glib dbus krb5
        mesa libGL libglvnd libxkbcommon

        freetype fontconfig

        libx11 libxext libxrandr
        libxrender libxcursor libxxf86vm
        libxi libxcb libxfixes
        libxcb-util libxcb-keysyms
        libxcb-wm libxcb-image
        libxcb-render-util
        xcb-util-cursor

        openssl curl

        fuse3
      ];
    }; #ld
  
    awg-tui.enable = true;

    bash.interactiveShellInit = ". /etc/nix-session-hook.sh";
    zsh.interactiveShellInit = builtins.readFile ./scripts/nix-session-hook.zsh;
  };

}
