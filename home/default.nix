{ primaryUser, ... }:
{
  imports = [
    ./packages.nix
    ./git.nix
    ./shell.nix
    ./aerospace.nix
    ./karabiner.nix
    ./cursor.nix
    ./ghostty.nix
  ];

  home = {
    username = primaryUser;
    stateVersion = "25.05";
    sessionVariables = {
      # shared environment variables
    };

    file.".hushlogin".text = "";
  };
}
