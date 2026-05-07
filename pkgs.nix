{ config, pkgs, soft, stable, lib, inputs, ... }: {

  environment.systemPackages = [
    stable.git stable.wget

    #audio
    pkgs.libpulseaudio

    #network
    stable.networkmanager_dmenu stable.networkmanagerapplet stable.networkmanager
    
    # systems build
    stable.cmake stable.libgcc stable.gnumake stable.glib stable.glui
    stable.libxinerama stable.libxcursor stable.gccgo15 stable.gcc
    stable.gnat15 stable.libgccjit stable.coreutils

    # graphical
    pkgs.vulkan-tools pkgs.vkbasalt

    # language
    pkgs.nixd pkgs.nil 
    pkgs.omnisharp-roslyn pkgs.roslyn pkgs.lemminx pkgs.netcoredbg
    (pkgs.dotnetCorePackages.combinePackages [
      pkgs.dotnetCorePackages.sdk_8_0-bin
      pkgs.dotnetCorePackages.sdk_9_0-bin
      pkgs.dotnetCorePackages.sdk_10_0-bin
    ])
    pkgs.rustc pkgs.cargo 
    pkgs.lua
    pkgs.jdk25 pkgs.kotlin pkgs.gradle soft.blockbench
    pkgs.python314

    soft.sqlite
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka material-design-icons
    nerd-fonts.jetbrains-mono icomoon-feather material-icons
    corefonts vista-fonts dejavu_fonts liberation_ttf
    jetbrains-mono adw-gtk3
    bibata-cursors bibata-cursors-translucent
    material-symbols capitaine-cursors
    papirus-icon-theme 
    adwaita-icon-theme adwaita-fonts
  ];

  programs = {
    xwayland ={
      enable = true;
    };

    appimage = {
      enable = true;
      binfmt = true;
      package = soft.appimage-run.override {
        extraPkgs = stable: with pkgs; [
          libpng libpng12
          libepoxy pcre2
          double-conversion
        ];
      };
    }; #appimage

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      protontricks = {
        enable = true;
      };
      extraCompatPackages = with stable; [
        proton-ge-bin
      ];
      extraPackages = with stable; [
        libgdiplus
        openssl
        xorg.libXcursor xorg.libXi xorg.libXinerama xorg.libXScrnSaver
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
        
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_vendor = "nvidia";
          nv_powermode_rw = 1;
        };
      };
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    }; #steam

    nix-ld = {
      enable = true;
      libraries = with soft; [
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

    zsh.enable = true; #root env
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome 
      pkgs.xdg-desktop-portal-gtk
    ];
    
    config = {
      common.default = [ "gtk" ];
      niri.default = [ "gnome" "gtk" ];
    };
  };

}
