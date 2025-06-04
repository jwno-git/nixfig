# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # use latest kernel for audio fx.
  boot.kernelPackages = pkgs.linuxPackages;

  # Enable zram at 50%
  zramSwap = {
	enable = true;
	memoryPercent = 50;
  };

  # Networking
  networking.hostName = "zenix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Regina";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # AMD graphics support
  hardware.graphics = {
	enable = true;
	extraPackages = with pkgs; [
		mesa
		amdvlk
    ];
  };

  # AMD GPU driver with stable parameters
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [ 
  "amdgpu.si_support=1" 
  "amdgpu.cik_support=1"
  "loglevel=3"
  "quiet"
  "udev.log_level=3"
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = false;

  # Enable Hyprland
  programs.hyprland.enable = true;

  # Enable Dconf
  programs.dconf.enable = true;

  # XDG Portal for screensharing
  xdg.portal = {
	enable = true;
	wlr.enable = true;
	extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Polkit Enable
  security.polkit.enable = true;

  # Environment Variables and Themes
  environment.variables = {
	EDITOR = "vim";
	VISUAL = "vim";
	GTK_THEME = "Tokyonight-Dark";
	XCURSOR_THEME = "RosePine";
	XCURSOR_SIZE = "32";
	HYPRCURSOR_THEME = "rose-pine-hyprcursor";
	HYPRCURSOR_SIZE = "32";
  };

  # Enable zsh
  programs.zsh.enable = true;

  # Disable root login
  users.users.root.hashedPassword = "!";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jwno = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
     shell = pkgs.zsh;
  };
  
  users.users.root = {
     shell = pkgs.zsh;
  };

  # Allow Unfree
  nixpkgs.config.allowUnfree = true;

  # Font configuration
  fonts = {
	packages = with pkgs; [
		font-awesome
		terminus_font
        ];
	fontconfig.enable = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
	#Apps
	brave
	eog
	firefox
	gimp
	gnome-calculator
	kdePackages.kdenlive
	libreoffice
	mpv
	standardnotes

	# Development
	git

	# File Manager
	lf

	# Fonts
	font-awesome
	terminus_font

	# Hyprland Ecosystem
	hyprland
	hyprlock
	hyprpaper
	hyprpicker

	# Network Management
        networkmanagerapplet

	# Sixel Support
	imagemagick
	libsixel

	# System utilities
	brightnessctl
	btop
	curl
	fastfetch
	fbset
	jq
	lxqt.lxqt-policykit
	tree
	vim
	wget

	# Terminal
	foot
	zsh

	# Theme Dependencies
	glib
	gsettings-desktop-schemas
	gtk3
	gtk4

	# Wayland
	cliphist
	dunst
	grim
	libnotify
	slurp
	swappy
	waybar
	wf-recorder
	wl-clipboard
	wlogout
	wofi

	# Audio/Bluetooth
	blueman
	pipewire
	pwvucontrol

	# Add makeDesktopItem to create custom desktop entries
	(makeDesktopItem {
	name = "btop";
	exec = "foot btop";
	icon = "htop";
	desktopName = "btop";
        comment = "Resource monitor";
        categories = [ "System" "Monitor" ];
        terminal = false;
        })

        (makeDesktopItem {
        name = "lf";
        exec = "foot lf";
        icon = "file-manager";
        desktopName = "lf";
        comment = "Terminal file manager";
        categories = [ "System" "FileManager" ];
        terminal = false;
     })
        # Hide printing-related desktop entries
        (runCommand "hide-printing-entries" {} ''
        mkdir -p $out/share/applications
        echo -e "[Desktop Entry]\nHidden=true" > $out/share/applications/org.gtk.PrintEditor4.desktop
        echo -e "[Desktop Entry]\nHidden=true" > $out/share/applications/cups.desktop
     '')
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

