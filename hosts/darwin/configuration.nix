{
  pkgs,
  primaryUser,
  ...
}:
{
  networking.hostName = "darwin";

  homebrew.casks = [
  # host-specific homebrew casks
  ];

  home-manager.users.${primaryUser} = {
    home.packages = with pkgs; [
    # host-specific home-manager configuration
    ];

    programs = {
      zsh = {
        initContent = ''
        '';
      };
    };
  };
}
