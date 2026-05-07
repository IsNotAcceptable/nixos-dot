{ config, lib, pkgs, stable, ... }: {
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us,ru";
      xkb.options = "grp:win_space_toggle";
      desktopManager = {
      	xterm.enable = false;
        mate.enable = false;
        lxqt.enable = false;
        xfce.enable = false;
        lumina.enable = false;
        kodi.enable = false;
        cinnamon.enable = false;
        cde.enable = false;
        
      };
      windowManager = {
        icewm.enable = false;
        qtile.enable = false;
        openbox.enable = false;
        bspwm.enable = false;   
        awesome = {
          enable = false;
        };
        herbstluftwm.enable = false;
      };
      displayManager.lightdm.enable = false;
    };
    
    desktopManager = {
      lomiri.enable = false;
      plasma6.enable = false;  
    };
    
    displayManager = {
      ly.enable = true;
      sddm.enable = false;
      sddm.wayland.enable = false;
      gdm.enable = false;
    };
  };

  programs = {
    sway = {
      enable = true;
      package = stable.swayfx;
      extraOptions = [ "--unsupported-gpu" ];
    };

    niri = {
      enable = true;
    };
  };

  environment.xfce.excludePackages = with pkgs; [
    mousepad xfce4-terminal xfce4-taskmanager
  ];

  environment = {
    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_SYNC_TO_VBLANK = "0";
      __GL_VRR_ALLOWED = "0";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WINEPREFIX = "/home/vibeman/1TB/wine";
      XDG_CURRENT_DESKTOP = "niri";
    };
  };

}
