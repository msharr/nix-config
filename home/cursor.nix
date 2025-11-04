{ pkgs, ... }:
let
  cursorExtensions = [
    "jnoortheen.nix-ide"
    "esbenp.prettier-vscode"
    "biomejs.biome"
    "pkief.material-icon-theme"
    "eamodio.gitlens"
    "lokalise.i18n-ally"
    "streetsidesoftware.code-spell-checker"
  ];
  
  installCursorExtensions = pkgs.writeShellScriptBin "install-cursor-extensions" ''
    set -euo pipefail
    
    if ! command -v cursor &> /dev/null; then
      echo "Cursor CLI not found. Make sure Cursor is installed and 'cursor' command is available."
      exit 1
    fi
    
    extensions=(
      ${builtins.concatStringsSep "\n      
      " (map (ext: "\"${ext}\"") cursorExtensions)}
    )
    
    for ext in "''${extensions[@]}"; do
      if [ -n "$ext" ]; then
        echo "Installing extension: $ext"
        cursor --install-extension "$ext" || echo "Failed to install $ext (may already be installed)"
      fi
    done
    
    echo "Done installing Cursor extensions"
  '';
  
  # Custom theme extension package.json
  themePackageJson = {
    name = "visual-studio-dark-custom";
    displayName = "Visual Studio Dark Custom";
    description = "Custom Visual Studio Dark theme with grey comments and dark status bar";
    version = "1.0.0";
    engines.vscode = "^1.0.0";
    categories = [ "Themes" ];
    contributes.themes = [
      {
        label = "Visual Studio Dark Custom";
        uiTheme = "vs-dark";
        path = "./themes/visual-studio-dark-custom.json";
      }
    ];
  };
  
  customTheme = {
    name = "Visual Studio Dark Custom";
    type = "dark";
    colors = {
      # Editor colors
      "editor.background" = "#1e1e1e";
      "editor.foreground" = "#d4d4d4";
      "editor.lineHighlightBackground" = "#282828";
      "editor.selectionBackground" = "#264f78";
      "editor.inactiveSelectionBackground" = "#3a3d41";
      
      # Sidebar
      "sideBar.background" = "#252526";
      "sideBar.foreground" = "#cccccc";
      "sideBar.border" = "#2b2b2b";
      "sideBarTitle.foreground" = "#bbbbbb";
      "sideBarSectionHeader.background" = "#00000000";
      "sideBarSectionHeader.foreground" = "#cccccc";
      
      # Activity bar
      "activityBar.background" = "#333333";
      "activityBar.foreground" = "#ffffff";
      "activityBar.inactiveForeground" = "#999999";
      "activityBar.border" = "#2b2b2b";
      "activityBarBadge.background" = "#007acc";
      "activityBarBadge.foreground" = "#ffffff";
      
      # Status bar - dark grey instead of blue
      "statusBar.background" = "#1e1e1e";
      "statusBar.foreground" = "#cccccc";
      "statusBar.noFolderBackground" = "#1e1e1e";
      "statusBar.debuggingBackground" = "#1e1e1e";
      "statusBar.border" = "#2b2b2b";
      
      # Title bar
      "titleBar.activeBackground" = "#3c3c3c";
      "titleBar.activeForeground" = "#cccccc";
      "titleBar.inactiveBackground" = "#3c3c3c";
      "titleBar.inactiveForeground" = "#999999";
      "titleBar.border" = "#2b2b2b";
      
      # Tabs
      "editorGroupHeader.tabsBackground" = "#252526";
      "tab.activeBackground" = "#1e1e1e";
      "tab.activeForeground" = "#ffffff";
      "tab.inactiveBackground" = "#2d2d2d";
      "tab.inactiveForeground" = "#999999";
      "tab.border" = "#252526";
      
      # Panel
      "panel.background" = "#1e1e1e";
      "panel.border" = "#2b2b2b";
      "panelTitle.activeBorder" = "#007acc";
      "panelTitle.activeForeground" = "#e7e7e7";
      "panelTitle.inactiveForeground" = "#999999";
      
      # Lists
      "list.activeSelectionBackground" = "#094771";
      "list.activeSelectionForeground" = "#ffffff";
      "list.hoverBackground" = "#2a2d2e";
      "list.inactiveSelectionBackground" = "#37373d";
      "list.focusBackground" = "#094771";
      
      # Input
      "input.background" = "#3c3c3c";
      "input.border" = "#3c3c3c";
      "input.foreground" = "#cccccc";
      "inputOption.activeBorder" = "#007acc";
      
      # Buttons
      "button.background" = "#0e639c";
      "button.foreground" = "#ffffff";
      "button.hoverBackground" = "#1177bb";
    };
    
    tokenColors = [
      # Comments - grey instead of green
      {
        scope = [ "comment" "punctuation.definition.comment" ];
        settings = {
          foreground = "#808080";
          fontStyle = "italic";
        };
      }
      # Keywords
      {
        scope = [ "keyword" "storage.type" "storage.modifier" ];
        settings.foreground = "#569cd6";
      }
      # Strings
      {
        scope = [ "string" ];
        settings.foreground = "#ce9178";
      }
      # Numbers
      {
        scope = [ "constant.numeric" ];
        settings.foreground = "#b5cea8";
      }
      # Functions
      {
        scope = [ "entity.name.function" "support.function" ];
        settings.foreground = "#dcdcaa";
      }
      # Classes/Types
      {
        scope = [ "entity.name.type" "entity.name.class" "support.type" "support.class" ];
        settings.foreground = "#4ec9b0";
      }
      # Variables
      {
        scope = [ "variable" "support.variable" ];
        settings.foreground = "#9cdcfe";
      }
      # Constants
      {
        scope = [ "constant.language" "support.constant" ];
        settings.foreground = "#569cd6";
      }
      # Operators
      {
        scope = [ "keyword.operator" ];
        settings.foreground = "#d4d4d4";
      }
      # HTML/XML Tags
      {
        scope = [ "entity.name.tag" "punctuation.definition.tag" ];
        settings.foreground = "#569cd6";
      }
      # HTML/XML Attributes
      {
        scope = [ "entity.other.attribute-name" ];
        settings.foreground = "#9cdcfe";
      }
      # Escape characters
      {
        scope = [ "constant.character.escape" ];
        settings.foreground = "#d7ba7d";
      }
      # Regex
      {
        scope = [ "string.regexp" ];
        settings.foreground = "#d16969";
      }
      # JSON keys
      {
        scope = [ "support.type.property-name.json" ];
        settings.foreground = "#9cdcfe";
      }
    ];
  };
in
{
  home.packages = [ installCursorExtensions ];
  
  home.file.".cursor/extensions/visual-studio-dark-custom/package.json".text = 
    builtins.toJSON themePackageJson;
  
  home.file.".cursor/extensions/visual-studio-dark-custom/themes/visual-studio-dark-custom.json".text = 
    builtins.toJSON customTheme;
  
  home.file.".cursor/User/settings.json".text = builtins.toJSON {
    "workbench.colorTheme" = "Visual Studio Dark Custom";
  };
  
}


  