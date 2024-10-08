# nix-env -p /nix/var/nix/profiles/system --delete-generations +5 
# nix-store --gc

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./gnome.nix
      ./general.nix
    ];

  system.stateVersion = "24.05"; 

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest; 
 
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;

  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;

  users.users.msharr = {
    isNormalUser = true;
    description = "Michael Shargorodsky";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  # General tools 
  git gh obs-studio mpv imagemagick fastfetch unzip
 
  # Work tools  
  vscode slack rpi-imager awscli2  
  
  # Browsers
  chromium firefox
  
  # Computer specific
  supergfxd
  ];

  programs.bash.shellAliases = {
  nshell="NIXPKGS_ALLOW_INSECURE=1 nix-shell --impure";
  dshell="NIXPKGS_ALLOW_INSECURE=1 nix develop --impure";
  };
}
