{ pkgs, ... }:
{
  home.file.".config/karabiner/karabiner.json".text = builtins.toJSON {
    global = {
      check_for_updates_on_startup = false;
      show_in_menu_bar = true;
      show_profile_name_in_menu_bar = false;
    };
    
    profiles = [{
      name = "Default";
      selected = true;
      
      complex_modifications = {
        rules = [
          {
            description = "Alt + Backspace → Open Raycast";
            manipulators = [{
              type = "basic";
              from = {
                key_code = "delete_or_backspace";
                modifiers = {
                  mandatory = [ "option" ];
                };
              };
              to = [{
                shell_command = "open -a Raycast";
              }];
            }];
          }
          {
            description = "Alt + Return → Open Ghostty";
            manipulators = [{
              type = "basic";
              from = {
                key_code = "return_or_enter";
                modifiers = {
                  mandatory = [ "option" ];
                };
              };
              to = [{
                shell_command = "open -a Ghostty";
              }];
            }];
          }
          {
            description = "Alt + Q → Quit Application";
            manipulators = [{
              type = "basic";
              from = {
                key_code = "q";
                modifiers = {
                  mandatory = [ "option" ];
                };
              };
              to = [{
                key_code = "q";
                modifiers = [ "command" ];
              }];
            }];
          }
          {
            description = "Alt + S → CleanShot Area Screenshot";
            manipulators = [{
              type = "basic";
              from = {
                key_code = "s";
                modifiers = {
                  mandatory = [ "option" ];
                };
              };
              to = [{
                shell_command = "open 'cleanshot://capture-area'";
              }];
            }];
          }
        ];
      };
      
      devices = [];
      
      virtual_hid_keyboard = {
        country_code = 3;  # 3 = UK/ISO keyboard
        keyboard_type_v2 = "iso";
      };
    }];
  };
}


