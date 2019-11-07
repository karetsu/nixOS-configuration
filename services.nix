# systemd type operations
{ config, lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # dconf enabler
  programs.dconf.enable = true;

  # List services that you want to enable:
  services = {
   
    clamav = {
      daemon.enable = true;
      updater.enable = true;
    };

    transmission = {
      enable = true;
      settings = {
        blocklist-enabled = true;
        blocklist-url = "http://john.bitsurge.net/public/biglist.p2p.gz";
        peer-port-random-on-start = true;
        encryption = 1;
        pex-enabled = true;
        port-forwarding-enabled = true;
        ratio-limit = 2;
        ratio-limit-enabled = true;
        start-added-torrents = true;
        trash-original-torrent-files = true;
      };
    };

    sonarr = {
      enable = true;
      user = "aloysius";
      group = "plex";
    };

    plex = {
      enable = true;
      user = "aloysius";
      package = (import (fetchTarball { 
        # url = "https://github.com/NixOS/nixpkgs/tarball/471869c9185fb610e67940a701eb13b1cfb335a4";
        url = "https://github.com/NixOS/nixpkgs/tarball/c22e76e450a74ef5a027b9868c6f600d64b69909";
        sha256 = "1klbclz8n4b9k1kfwv806bqdavld1mg32l1vxsmnrqzr6zck1c54"; 
      }) {config.allowUnfree = true; }).plex;
    };

    xserver = {
      enable = true;
      layout = "gb";

      displayManager = {
        gdm = {
          enable = false; # true;
          wayland = false; # NVIDIA drivers don't support it :(
        };
	lightdm = {
	  enable = true;
          background = "/media/dipper/Images/goat.jpg";
	  # other options
	  greeters.gtk = {
            theme = {
              package = pkgs.nordic;
              name = "Nordic";
            };
            iconTheme = {
              package = pkgs.paper-icon-theme;
              name = "Paper";
            };
            indicators = [ "~host" "~spacer"
                           "~clock" "~spacer"
                           "~session" "~power"
                         ];
          };
	};
      };

      desktopManager = {
        gnome3.enable = true;
        xterm.enable = false;
      };

      windowManager = {
	i3 = {
          enable = true;
          package = pkgs.i3-gaps;
	  extraPackages = with pkgs; [
            i3status
            i3lock-color
            i3blocks
	  ];
	};

        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = haskellPackages: [
            haskellPackages.xmonad-contrib
            haskellPackages.xmonad-extras
            haskellPackages.xmonad-screenshot
            haskellPackages.xmonad-utils
            haskellPackages.xmonad-volume
            haskellPackages.xmonad
          ];
        };
      };

      videoDrivers = [ "nvidia" ];
    };

    gnome3.gnome-keyring.enable = true;

    dbus = {
      packages = [ pkgs.gutenprint pkgs.gnome3.dconf ];
    };

    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };

    postgresql = {
      enable = true;
    };

  };
}
