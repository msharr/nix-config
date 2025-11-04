{ pkgs, ... }:
{
  home.file.".config/ghostty/config".text = ''
    background = 1a1f25
    background-opacity = 0.72
    background-blur = 20
    
    foreground = ffffff
    
    palette = 0=000000
    palette = 1=ff0000
    palette = 2=00ff00
    palette = 3=ffff00
    palette = 4=0000ff
    palette = 5=ff00ff
    palette = 6=00ffff
    palette = 7=ffffff
    palette = 8=808080
    palette = 9=ff8080
    palette = 10=00ff00
    palette = 11=ffff80
    palette = 12=8080ff
    palette = 13=ff80ff
    palette = 14=80ffff
    palette = 15=ffffff
    
    cursor-style = block
    
    selection-background = 71717a
    selection-foreground = fafafa
    
    window-padding-x = 10
    window-padding-y = 10
    
    font-family = SF Mono, Monaco, Menlo, monospace
    font-size = 17
    
    scrollback-limit = 10000
  '';
}

