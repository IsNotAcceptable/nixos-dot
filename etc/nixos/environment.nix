{ config, lib, pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us,ru";
      xkb.options = "grp:win_space_toggle";
      displayManager.lightdm.enable = false;
    };

    displayManager = {
      ly.enable = true;
      sddm.enable = false;
      gdm.enable = false;
    };

    desktopManager = {
      
    };
    
    logind = {
      lidSwitch = "hibernate";
      lidSwitchExternalPower = "hibernate";
    };
  };

  programs = {
    driftwm.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common.default = [ "gtk" ];
      driftwm.default = [ "gtk" ];
    };
  };
}
