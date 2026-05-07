{ config, lib, pkgs, soft, stable, ... }: {
  systemd = {
    user = {
      services = {
        arrpc = {
          description = "Discord RPC bridge for browser";
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            ExecStart = "${soft.arrpc}/bin/arrpc";
            Restart = "on-failure";
          };
        };
      };
    };
  };

  services = {

    flatpak = {
      enable = true;
    };

    zerotierone = {
      enable = true;
    };

    printing = {
      enable = true;

    };

    fstrim.enable = true;
    gvfs.enable = true;
    udisks2 = {
      enable = true;
    };
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
    udev.extraRules = ''
      SUBSYSTEM=="block", ENV{ID_SERIAL}=="WDC_WD2500BEVS-22UST0_WD-WXC108964126", ATTR{queue/scheduler}="bfq"
  '';
    
    power-profiles-daemon.enable = true;
    upower.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };
  security.rtkit.enable = true;

  #qemu virt
  virtualisation.libvirtd = {
    enable = true;
    package = stable.libvirt;
    qemu = {
      package = stable.qemu_full;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  services.spice-vdagentd.enable = true;
  programs.virt-manager.enable = true;

}
