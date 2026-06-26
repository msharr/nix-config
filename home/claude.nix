{ config, ... }:
{
  # Symlink ~/.claude/skills to the live repo folder so edits apply
  # immediately without a rebuild. Only this path is managed — the rest
  # of ~/.claude (memory, settings, projects) is left untouched.
  #
  # Add a skill by creating home/claude/skills/<name>/SKILL.md.
  home.file.".claude/skills".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nix/home/claude/skills";
}
