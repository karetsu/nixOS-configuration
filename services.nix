# systemd type operations
{ config, lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # List services that you want to enable:
  services = {
 
    # VPN
    openvpn.servers = {
      home = { 
        config = '' 
          config /root/.vpn/udp/uk971.nordvpn.com.udp.ovpn 
          auth-user-pass /root/.vpn/aloysius.key
        '';
      };
    };
  
    # antivirus
    clamav = {
      daemon.enable = true;
      updater.enable = true;
    };

    # keybase stuff
    keybase.enable = true;
    kbfs.enable = true;

    # torrent
    transmission = {
      enable = true;

      user = "aloysius";
      home = "/home/aloysius/Downloads/torrents";
      settings = {
        blocklist-enabled = true;
        download-dir = "/home/aloysius/Downloads/torrents";
        incomplete-dir-enabled = false;
        watch-dir-enabled = true;
        watch-dir = "/home/aloysius/Downloads";
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
 
    # media watchlist+snatcher
    sonarr = {
      enable = true;
      user = "aloysius";
      group = "plex";
    };

    # media platform
    plex = {
      enable = true;
      user = "aloysius";
      package = (import (fetchTarball { 
        url = "https://github.com/NixOS/nixpkgs/tarball/88f24e842b9c3acd347410d17c2211551a20df8a";
        sha256 = "0wi4n7xw1lw830d51yz420p7y7mrdh541z4yckqb9jgc4ar2jgf9";
      }) {config.allowUnfree = true; }).plex;
    };

    # glitz
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
                           "~session" "~power" ];
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
            i3blocks ];
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

    # bus
    dbus = { 
      packages = [ pkgs.gutenprint pkgs.gnome3.dconf ];
    };
    gnome3.gnome-keyring.enable = true;

    # system printing services
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };

    # databases
    postgresql = {
      enable = true;
    };
  };
}
