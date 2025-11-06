{ primaryUser, ... }:
{
  programs.git = {
    enable = true;

    lfs.enable = true;

    ignores = [ "**/.DS_STORE" ".vscode/" ".vscode/*" ];

    settings = {
      user = {
        name = "msharr";
        email = "m.shargorodsky@outlook.com";
      };
      github = {
        user = primaryUser;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
