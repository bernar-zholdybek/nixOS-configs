{self, inputs, ... }: {

    flake.nixosModules.myMachineConfiguration = { config, lib, pkgs, ... }: {
      imports = [
          self.nixosModules.myMachineHardware
          self.nixosModules.niri

          ];

      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.cudaSupport = false;

      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;



      services.gnome.gnome-keyring.enable = true;
      programs.seahorse.enable = true;
      security.pam.services.login.enableGnomeKeyring = true;
      services.dbus.enable = true;



      networking.hostName = "bekazh"; # Hostname.
      hardware.enableRedistributableFirmware = true;
      time.timeZone = "Asia/Kuala_Lumpur";



      services.pipewire = {
          enable = true;
          pulse.enable = true;
          alsa.enable = true;
          wireplumber.enable = true;
      };



      # --- Programs ---

      # programs.hyprland.enable = true;
      services.printing.enable = false;
      services.touchegg.enable = true;
      networking.networkmanager.enable = true;


      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      services.blueman.enable = true;     # Bluetooth tray + manager

      services.power-profiles-daemon.enable = false;
      services.upower.enable = true;
      services.tlp.enable = true;
      services.libinput.enable = true;

      virtualisation.waydroid.enable = true;





      services.displayManager.defaultSession = "niri";

      nix.settings.trusted-users = [ "root" "bernar" ];
      services.getty.autologinUser = "bernar";
      users.users.bernar = {
          isNormalUser = true;
          extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
          packages = with pkgs; [
          tree
          ];
      };

      xdg.mime.defaultApplications = {
          "application/pdf" = "firefox.desktop";
          "text/x-python" = "code.desktop";
          "text/plain" = "kate.desktop";
      };
      xdg.portal = {
          enable = true;
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
          config.common.default = [ "gtk" ];

          # ADD THIS LINE: It tells Niri to use the GTK picker specifically.
          #config.niri.default = [ "gtk" ];
      };

      services.gvfs.enable = true; # Core support for MTP/Storage
      services.udisks2.enable = true;
      programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
            thunar-volman # Auto-management of removable drives
        ];
        };
      # 3. CRITICAL: Thunar needs Xfconf to remember settings & handle mounting
        programs.xfconf.enable = true;

        # 4. Give yourself permission to mount (Polkit)
        security.polkit.enable = true;



      environment.systemPackages = with pkgs; [
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
        fonts.packages = with pkgs; [
            nerd-fonts.jetbrains-mono
        ];




      programs.xwayland.enable = true;
      # --- Graphics ---

      hardware.graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
          libva-vdpau-driver
          ];
      };


      services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
      hardware.nvidia.open = true;


      # ADD THIS LINE: This is strictly required for Xwayland on Nvidia
      hardware.nvidia.modesetting.enable = true;


      hardware.nvidia.prime = {
          offload = {
          enable = true;
          enableOffloadCmd = true; };

          amdgpuBusId = "PCI:4:0:0"; # integrated
          nvidiaBusId = "PCI:1:0:0"; # dedicated
      };


      environment.sessionVariables = {
          # Nvidia Fixes
          WLR_NO_HARDWARE_CURSORS = "1";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          LIBVA_DRIVER_NAME = "nvidia";
          NVD_BACKEND = "direct";

          # Session Identity
          XDG_CURRENT_DESKTOP = "niri";
          XDG_SESSION_TYPE = "wayland";

          # Fix for GTK apps and themes
          GTK_USE_PORTAL = "1";
          XCURSOR_THEME = "Nordzy-cursors";
          XCURSOR_SIZE = "24";
          XDG_MENU_PREFIX = "plasma-";
      };

      programs.dconf.enable = true;


      system.stateVersion = "25.05";
      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      };
}
