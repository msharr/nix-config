{
  pkgs,
  inputs,
  self,
  primaryUser,
  ...
}:
{
  imports = [
    ./homebrew.nix
    ./settings.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    enable = true;
    package = pkgs.nixVersions.latest;
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 3; Minute = 0; };
      options = "--delete-older-than 14d";
    };
    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfree = true;

  nix-homebrew = {
    user = primaryUser;
    enable = true;
    autoMigrate = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${primaryUser} = {
      imports = [
        ../home
      ];
    };
    extraSpecialArgs = {
      inherit inputs self primaryUser;
    };
  };

  system.primaryUser = primaryUser;
  users.users.${primaryUser} = {
    home = "/Users/${primaryUser}";
    shell = pkgs.zsh;
  };
  environment = {
    systemPath = [
      "/opt/homebrew/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };
}
