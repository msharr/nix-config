{ config, ... }:
{
  home.file.".agents/skills".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nix/home/claude/skills";
}
