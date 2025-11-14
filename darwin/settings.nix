{ self, ... }:
{
  # touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # system defaults and preferences
  system = {
    stateVersion = 6;
    configurationRevision = self.rev or self.dirtyRev or null;

    startup.chime = false;

    defaults = {
      loginwindow = {
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };

      finder = {
        AppleShowAllFiles = true; # hidden files
        AppleShowAllExtensions = true; # file extensions
        _FXShowPosixPathInTitle = true; # title bar full path
        ShowPathbar = true; # breadcrumb nav at bottom
        ShowStatusBar = true; # file count & disk space
      };

      NSGlobalDomain = {
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
      };

      dock = {
        # Automatically hide and show the Dock
        autohide = true;
        # Speed up dock hiding animation
        autohide-time-modifier = 0.5;
        # Remove delay for showing when hovering at edge
        autohide-delay = 0.0;
        # Position dock at bottom
        orientation = "bottom";
      };

      spaces = {
        # Displays have separate Spaces (prevents black screen on other monitor in fullscreen)
        spans-displays = false;
      };
    };
  };
}
