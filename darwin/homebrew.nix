{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    caskArgs.no_quarantine = true;
    global.brewfile = true;

    casks = [
      # utilities
      "cleanshot" "raycast" "karabiner-elements" "scroll-reverser" "eqmac" "keyboardcleantool"

      # development
      "cursor" "ghostty" "visual-studio-code" "docker-desktop" "session-manager-plugin" "claude-code" 
      

      # productivity
      "slack" "whatsapp" "notion" "protonvpn" "spotify" "postman" "linear-linear" 

      # browsers
      "zen" "google-chrome" "claude" 
    ];
    brews = ["supabase" "awscli"]; 
    taps = [];
    masApps = {
    #  xcode = 497799835;      
    };
  };
}
