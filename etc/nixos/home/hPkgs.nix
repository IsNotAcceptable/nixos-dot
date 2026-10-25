{ inputs, pkgs, config, lib, ... }: 
{
  home.packages = with pkgs; [
    qemu quickemu virt-manager virt-viewer virtio-win
    virtiofsd spice spice-gtk spice-protocol

    wl-clipboard grim slurp

    firefox qbittorrent

    vlc

    heroic
  ];

  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "IsNotAcceptable";
        user.email = "184727191+IsNotAcceptable@users.noreply.github.com";
        core.editor = "nvim";
        color.ui = true;
      };
    }; #git

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      dotDir = "${config.home.homeDirectory}/.config/zsh";

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
        update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      };

      initContent = ''
        fastfetch
      '';

    }; #zsh
  };
}
