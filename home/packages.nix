{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      btop
      gh
      zoxide
    ];
  };
}
