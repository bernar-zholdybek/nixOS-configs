{self, inputs, ... }: {

    flake.nixosModules.myMachineConfiguration = { config, lib, pkgs, ... }: {
      imports = [
          self.nixosModules.myMachineHardware
          self.nixosModules.niri
      ];

      nixpkgs.config.allowUnfree = true;

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      services.gnome.gnome-keyring.enable = true;
      programs.seahorse.enable = true;
      security.pam.services.login.enableGnomeKeyring = true;
      services.dbus.enable = true;

      networking.hostName = "bekazh"; 
      hardware.enableRedistributableFirmware = true;
      time.timeZone = "Asia/Kuala_Lumpur";

      services.pipewire = {
          enable = true;
          pulse.enable = true;
          alsa.enable = true;
          wireplumber.enable = true;
      };

      services.touchegg.enable = true;
      networking.networkmanager.enable = true;
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      services.blueman.enable = true;
      services.power-profiles-daemon.enable = false;
      services.tlp.enable = true;
      services.libinput.enable = true;

      virtualisation.waydroid.enable = true;
      services.displayManager.defaultSession = "niri";
      services.getty.autologinUser = "bernar";

      users.users.bernar = {
          isNormalUser = true;
          extraGroups = [ "wheel" "networkmanager" "video" ]; 
      };

      # ИСПРАВЛЕНИЕ ФАЙЛ-ПИКЕРА
      xdg.portal = {
          enable = true;
          extraPortals = [ 
            pkgs.xdg-desktop-portal-gtk 
            pkgs.xdg-desktop-portal-gnome 
          ];
          config = lib.mkForce {
            common.default = [ "gtk" ];
            niri.default = [ "gnome" "gtk" ];
          };
      };

      services.gvfs.enable = true; 
      services.udisks2.enable = true;
      services.tumbler.enable = true;

      programs.thunar = {
        enable = true;
        plugins = with pkgs; [ thunar-volman thunar-archive-plugin ];
      };

      programs.xfconf.enable = true;
      security.polkit.enable = true;

      environment.systemPackages = with pkgs; [
            adwaita-icon-theme
            jmtpfs
            # --- Core Utilities ---
            vim
            wget
            p7zip
            networkmanagerapplet
            wl-clipboard

            # --- Development ---
            gcc
            gdb
            glib
            gsettings-desktop-schemas
            binutils
            devenv

            # --- GUI Apps ---
            firefox
            vscode
            vesktop
            obs-studio
            kitty
            vlc
            mpv
            libreoffice
            inkscape
            gimp
            kdePackages.kate
            obsidian

            # --- Niri/Wayland Essentials ---
            brightnessctl
            pavucontrol
            grim
            slurp
            pamixer
            playerctl
            nordzy-cursor-theme
            xwayland-satellite

            thunar                     # Lightweight file manager
            thunar-archive-plugin      # Lets you right-click to extract files
            lxmenu-data                # Keeps your "Open With" menus working
            shared-mime-info           # Helps apps identify file types

            # --- Eye Candy ---
            cmatrix
            cava
            mpvpaper
        ];

        programs.steam.enable = true;
        programs.localsend.enable = true;
        programs.kdeconnect.enable = true;
        fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
        programs.xwayland.enable = true;

        # Графика (Nvidia)
        hardware.graphics = { enable = true; enable32Bit = true; };
        services.xserver.videoDrivers = [ "nvidia" ];
        hardware.nvidia = {
            open = true;
            modesetting.enable = true;
            prime = {
                offload.enable = true;
                offload.enableOffloadCmd = true; 
                amdgpuBusId = "PCI:4:0:0"; 
                nvidiaBusId = "PCI:1:0:0";
            };
        };

        environment.sessionVariables = {
            WLR_NO_HARDWARE_CURSORS = "1";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            LIBVA_DRIVER_NAME = "nvidia";
            XDG_CURRENT_DESKTOP = "niri";
            XDG_SESSION_TYPE = "wayland";
            GTK_USE_PORTAL = "1"; 
            XCURSOR_THEME = "Nordzy-cursors";
            XCURSOR_SIZE = "24";
        };

        programs.dconf.enable = true;
        system.stateVersion = "25.05";
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
      };
}
