{
  zjstatus,
  ...
}:
{
  programs = {
    zellij = {
      enable = true;
      settings = {
        theme = "nord-custom";
        web_client = false;
        pane_frames = false;
        show_startup_tips = false;
        ui = {
          pane_frames = {
            hide_session_name = true;
          };
        };
      };
      themes = {
        nord-custom = ''
          themes {
            nord-custom {
              text_unselected {
                base 229 233 240
                background 59 66 82
                emphasis_0 208 135 112
                emphasis_1 136 192 208
                emphasis_2 163 190 140
                emphasis_3 180 142 173
              }
              text_selected {
                base 229 233 240
                background 59 66 82
                emphasis_0 208 135 112
                emphasis_1 136 192 208
                emphasis_2 163 190 140
                emphasis_3 180 142 173
              }
              ribbon_selected {
                base 59 66 82
                background 163 190 140
                emphasis_0 191 97 106
                emphasis_1 208 135 112
                emphasis_2 180 142 173
                emphasis_3 129 161 193
              }
              ribbon_unselected {
                base 59 66 82
                background 216 222 233
                emphasis_0 191 97 106
                emphasis_1 229 233 240
                emphasis_2 129 161 193
                emphasis_3 180 142 173
              }
              table_title {
                base 163 190 140
                background 0
                emphasis_0 208 135 112
                emphasis_1 136 192 208
                emphasis_2 163 190 140
                emphasis_3 180 142 173
              }
              table_cell_selected {
                base 229 233 240
                background 46 52 64
                emphasis_0 208 135 112
                emphasis_1 136 192 208
                emphasis_2 163 190 140
                emphasis_3 180 142 173
              }
              table_cell_unselected {
                base 229 233 240
                background 59 66 82
                emphasis_0 208 135 112
                emphasis_1 136 192 208
                emphasis_2 163 190 140
                emphasis_3 180 142 173
              }
              list_selected {
                base 229 233 240
                background 46 52 64
                emphasis_0 208 135 112
                emphasis_1 136 192 208
                emphasis_2 163 190 140
                emphasis_3 180 142 173
              }
              list_unselected {
                base 229 233 240
                background 59 66 82
                emphasis_0 208 135 112
                emphasis_1 136 192 208
                emphasis_2 163 190 140
                emphasis_3 180 142 173
              }
              frame_selected {
                base 55 63 81
                background 0
                emphasis_0 208 135 112
                emphasis_1 136 192 208
                emphasis_2 180 142 173
                emphasis_3 0
              }
              frame_highlight {
                base 129 161 193
                background 0
                emphasis_0 180 142 173
                emphasis_1 208 135 112
                emphasis_2 208 135 112
                emphasis_3 208 135 112
              }
              exit_code_success {
                base 163 190 140
                background 0
                emphasis_0 136 192 208
                emphasis_1 59 66 82
                emphasis_2 180 142 173
                emphasis_3 129 161 193
              }
              exit_code_error {
                base 191 97 106
                background 0
                emphasis_0 235 203 139
                emphasis_1 0
                emphasis_2 0
                emphasis_3 0
              }
              multiplayer_user_colors {
                player_1 180 142 173
                player_2 129 161 193
                player_3 0
                player_4 235 203 139
                player_5 136 192 208
                player_6 0
                player_7 191 97 106
                player_8 0
                player_9 0
                player_10 0
              }
            }
          }
        '';
      };
      layouts = {
        default = ''
          layout {
            pane split_direction="vertical" {
              pane
            }

            pane size=1 borderless=true {
              plugin location="file:${zjstatus}/bin/zjstatus.wasm" {
                format_left  "{mode} {tabs}"
                format_right "#[fg=#4C566A,bg=#2E3440] {command_termstate}"
                format_space "#[bg=#2E3440]"

                command_termstate_command    "bash -c \"cat /tmp/.zjstatus_''${ZELLIJ_SESSION_NAME}\""
                command_termstate_format     "{stdout}"
                rommand_termstate_rendermode "raw"

                mode_normal          "#[bg=#88C0D0] "
                mode_locked          "#[bg=#D08770] "
                mode_resize          "#[bg=#A3BE8C] "
                mode_pane            "#[bg=#EBCB8B] "
                mode_tab             "#[bg=#B48EAD] "
                mode_scroll          "#[bg=#88C0D0] "
                mode_enter_search    "#[bg=#5E81AC] "
                mode_search          "#[bg=#5E81AC] "
                mode_rename_tab      "#[bg=#B48EAD] "
                mode_rename_pane     "#[bg=#EBCB8B] "
                mode_session         "#[bg=#BF616A] "
                mode_move            "#[bg=#A3BE8C] "
                mode_prompt          "#[bg=#EBCB8B] "
                mode_tmux            "#[bg=#EBCB8B] "
                mode_default_to_mode "normal"

                tab_normal               "#[fg=#4C566A,bg=#2E3440] {name} {fullscreen_indicator}{sync_indicator}{floating_indicator}"
                tab_active               "#[fg=#D8DEE9,bg=#3c4353,bold] {name} {fullscreen_indicator}{sync_indicator}{floating_indicator}"
                tab_fullscreen_indicator "□ "
                tab_sync_indicator       "  "
                tab_floating_indicator   "󰉈 "
              }
            }
          }
        '';
      };
      extraConfig = ''
        load_plugins {
          "file:${zjstatus}/bin/zjstatus.wasm" {}
        }

        default_mode "locked"

        keybinds {
          normal {
            bind "n" { NewPane; }          
          }

          locked {
            bind "Alt h" { MoveFocusOrTab "Left"; }
            bind "Alt l" { MoveFocusOrTab "Right"; }
          }
        }
      '';
    };
  };
}
