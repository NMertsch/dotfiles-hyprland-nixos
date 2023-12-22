{ inputs, config, pkgs, ... }:

{
  system.stateVersion = "23.05";

  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.pipewire.wireplumber.enable = true;

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.sessionVariables = {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    HY3_LOCATION = "${inputs.hy3.packages.x86_64-linux.hy3}/lib/libhy3.so";
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # system
    pkgs.wget
    pkgs.file
    pkgs.psmisc
    pkgs.tree
    pkgs.htop
    pkgs.libnotify
    pkgs.brightnessctl

    # apps
    pkgs.firefox
    pkgs.bitwarden
    pkgs.ranger
    pkgs.mpv
    pkgs.feh
    pkgs.obs-studio

    # desktop
    pkgs.pavucontrol
    pkgs.swaylock
    pkgs.nwg-bar
    pkgs.alacritty
    pkgs.rofi-wayland
    pkgs.waybar
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    inputs.hy3.packages.${pkgs.system}.hy3
    inputs.hyprpaper.packages.${pkgs.system}.hyprpaper

    # dev tools
    pkgs.jetbrains.idea-ultimate
    pkgs.jetbrains.pycharm-professional
    pkgs.jetbrains.rust-rover
  ];

  fonts.packages = with pkgs; [
    pkgs.font-awesome
    pkgs.roboto
    pkgs.roboto-mono
    (
      nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
        ];
      }
    )
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  }; 

  security.pam.services.swaylock = {};

  users.users.niklas = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
#      "audio"
    ];
  };
}
