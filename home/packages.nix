{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # cli
      btop gh zoxide  
    ];
  };
}
