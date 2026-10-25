{ config, lib, pkgs, ... }:
{
  services = {
    flatpak = {
      enable = true;
    };

    printing = {
      enable = true;
      browsing = true;
      defaultShared = true;
      drivers = [
	pkgs.gutenprint
	pkgs.cups-filters
	pkgs.splix
      ];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
	enable = true;
	addresses = true;
	userServices = true;
      };
    };

    fstrim.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;

    blueman = {
      enable = true;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    tlp = {
      enable = true;
      settings = {
	# Режимы работы процессора
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        # Тонкая настройка Intel Energy Performance Hints
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # Ограничиваем максимальную частоту на батарее (для экономии)
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MAX_PERF_ON_BAT = 60; # Процессор не будет горячеть без сети

        # Энергосбережение встроенной графики Intel
        INTEL_GPU_MIN_FREQ_ON_AC = 300;
        INTEL_GPU_MIN_FREQ_ON_BAT = 300;
        INTEL_GPU_MAX_FREQ_ON_AC = 1000;
        INTEL_GPU_MAX_FREQ_ON_BAT = 600; # Снижает пиковое потребление GPU
        INTEL_GPU_BOOST_ON_AC = "yes";
        INTEL_GPU_BOOST_ON_BAT = "no";
      };
    };

    thermald.enable = true;
  };
  security.rtkit.enable = true;

  #qemu virt
  virtualisation.libvirtd = {
    enable = true;
    package = pkgs.libvirt;
    allowedBridges = [
      "virbr0" "br0"
    ];
    qemu = {
      package = pkgs.qemu;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  services.spice-vdagentd.enable = true;
  programs.virt-manager.enable = true;
}
