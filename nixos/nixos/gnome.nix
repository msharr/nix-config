{ config, pkgs, ... }:

{
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude GNOME Extras.
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-text-editor
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    gnome-calculator
    yelp # help viewer
    gnome-maps
    gnome-weather
    gnome-contacts
    simple-scan
  ]);

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  environment.systemPackages = with pkgs.gnomeExtensions; [
    blur-my-shell
    panel-corners
    appindicator
  ];
}
