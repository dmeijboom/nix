{
  lib,
  pkgs,
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

        keybinds clear-defaults=true {
          locked {
            bind "Alt g" { SwitchToMode "Normal"; }
          }
          resize {
            bind "Alt r" { SwitchToMode "Normal"; }
            bind "h" "Left" { Resize "Increase Left"; }
            bind "j" "Down" { Resize "Increase Down"; }
            bind "k" "Up" { Resize "Increase Up"; }
            bind "l" "Right" { Resize "Increase Right"; }
            bind "H" { Resize "Decrease Left"; }
            bind "J" { Resize "Decrease Down"; }
            bind "K" { Resize "Decrease Up"; }
            bind "L" { Resize "Decrease Right"; }
            bind "=" "+" { Resize "Increase"; }
            bind "-" { Resize "Decrease"; }
          }
          pane {
            bind "Alt p" { SwitchToMode "Normal"; }
            bind "h" "Left" { MoveFocus "Left"; }
            bind "l" "Right" { MoveFocus "Right"; }
            bind "j" "Down" { MoveFocus "Down"; }
            bind "k" "Up" { MoveFocus "Up"; }
            bind "p" { SwitchFocus; }
            bind "n" { NewPane; SwitchToMode "Normal"; }
            bind "d" { NewPane "Down"; SwitchToMode "Normal"; }
            bind "r" { NewPane "Right"; SwitchToMode "Normal"; }
            bind "s" { NewPane "stacked"; SwitchToMode "Normal"; }
            bind "x" { CloseFocus; SwitchToMode "Normal"; }
            bind "f" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
            bind "z" { TogglePaneFrames; SwitchToMode "Normal"; }
            bind "w" { ToggleFloatingPanes; SwitchToMode "Normal"; }
            bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "Normal"; }
            bind "c" { SwitchToMode "RenamePane"; PaneNameInput 0;}
            bind "i" { TogglePanePinned; SwitchToMode "Normal"; }
          }
          move {
            bind "Alt m" { SwitchToMode "Normal"; }
            bind "n" "Tab" { MovePane; }
            bind "p" { MovePaneBackwards; }
            bind "h" "Left" { MovePane "Left"; }
            bind "j" "Down" { MovePane "Down"; }
            bind "k" "Up" { MovePane "Up"; }
            bind "l" "Right" { MovePane "Right"; }
          }
          tab {
            bind "Alt t" { SwitchToMode "Normal"; }
            bind "r" { SwitchToMode "RenameTab"; TabNameInput 0; }
            bind "h" "Left" "Up" "k" { GoToPreviousTab; }
            bind "l" "Right" "Down" "j" { GoToNextTab; }
            bind "n" { NewTab; SwitchToMode "Normal"; }
            bind "x" { CloseTab; SwitchToMode "Normal"; }
            bind "s" { ToggleActiveSyncTab; SwitchToMode "Normal"; }
            bind "b" { BreakPane; SwitchToMode "Normal"; }
            bind "]" { BreakPaneRight; SwitchToMode "Normal"; }
            bind "[" { BreakPaneLeft; SwitchToMode "Normal"; }
            bind "1" { GoToTab 1; SwitchToMode "Normal"; }
            bind "2" { GoToTab 2; SwitchToMode "Normal"; }
            bind "3" { GoToTab 3; SwitchToMode "Normal"; }
            bind "4" { GoToTab 4; SwitchToMode "Normal"; }
            bind "5" { GoToTab 5; SwitchToMode "Normal"; }
            bind "6" { GoToTab 6; SwitchToMode "Normal"; }
            bind "7" { GoToTab 7; SwitchToMode "Normal"; }
            bind "8" { GoToTab 8; SwitchToMode "Normal"; }
            bind "9" { GoToTab 9; SwitchToMode "Normal"; }
            bind "Tab" { ToggleTab; }
          }
          scroll {
            bind "Alt s" { SwitchToMode "Normal"; }
            bind "e" { EditScrollback; SwitchToMode "Normal"; }
            bind "s" { SwitchToMode "EnterSearch"; SearchInput 0; }
            bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
            bind "j" "Down" { ScrollDown; }
            bind "k" "Up" { ScrollUp; }
            bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
            bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
            bind "d" { HalfPageScrollDown; }
            bind "u" { HalfPageScrollUp; }
            // uncomment this and adjust key if using copy_on_select=false
            // bind "Alt c" { Copy; }
          }
          search {
            bind "Alt s" { SwitchToMode "Normal"; }
            bind "Alt c" { ScrollToBottom; SwitchToMode "Normal"; }
            bind "j" "Down" { ScrollDown; }
            bind "k" "Up" { ScrollUp; }
            bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
            bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
            bind "d" { HalfPageScrollDown; }
            bind "u" { HalfPageScrollUp; }
            bind "n" { Search "down"; }
            bind "p" { Search "up"; }
            bind "c" { SearchToggleOption "CaseSensitivity"; }
            bind "w" { SearchToggleOption "Wrap"; }
            bind "o" { SearchToggleOption "WholeWord"; }
          }
          entersearch {
            bind "Alt c" "Esc" { SwitchToMode "Scroll"; }
            bind "Enter" { SwitchToMode "Search"; }
          }
          renametab {
            bind "Alt c" { SwitchToMode "Normal"; }
            bind "Esc" { UndoRenameTab; SwitchToMode "Tab"; }
          }
          renamepane {
            bind "Alt c" { SwitchToMode "Normal"; }
            bind "Esc" { UndoRenamePane; SwitchToMode "Pane"; }
          }
          session {
            bind "Alt o" { SwitchToMode "Normal"; }
            bind "Alt s" { SwitchToMode "Scroll"; }
            bind "d" { Detach; }
            bind "w" {
              LaunchOrFocusPlugin "session-manager" {
                floating true
                move_to_focused_tab true
              };
              SwitchToMode "Normal"
            }
            bind "c" {
              LaunchOrFocusPlugin "configuration" {
                floating true
                move_to_focused_tab true
              };
              SwitchToMode "Normal"
            }
            bind "p" {
              LaunchOrFocusPlugin "plugin-manager" {
                floating true
                move_to_focused_tab true
              };
              SwitchToMode "Normal"
            }
            bind "a" {
              LaunchOrFocusPlugin "zellij:about" {
                floating true
                move_to_focused_tab true
              };
              SwitchToMode "Normal"
            }
            bind "s" {
              LaunchOrFocusPlugin "zellij:share" {
                floating true
                move_to_focused_tab true
              };
              SwitchToMode "Normal"
            }
          }
          tmux {
            bind "[" { SwitchToMode "Scroll"; }
            bind "Alt b" { Write 2; SwitchToMode "Normal"; }
            bind "\"" { NewPane "Down"; SwitchToMode "Normal"; }
            bind "%" { NewPane "Right"; SwitchToMode "Normal"; }
            bind "z" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
            bind "c" { NewTab; SwitchToMode "Normal"; }
            bind "," { SwitchToMode "RenameTab"; }
            bind "p" { GoToPreviousTab; SwitchToMode "Normal"; }
            bind "n" { GoToNextTab; SwitchToMode "Normal"; }
            bind "Left" { MoveFocus "Left"; SwitchToMode "Normal"; }
            bind "Right" { MoveFocus "Right"; SwitchToMode "Normal"; }
            bind "Down" { MoveFocus "Down"; SwitchToMode "Normal"; }
            bind "Up" { MoveFocus "Up"; SwitchToMode "Normal"; }
            bind "h" { MoveFocus "Left"; SwitchToMode "Normal"; }
            bind "l" { MoveFocus "Right"; SwitchToMode "Normal"; }
            bind "j" { MoveFocus "Down"; SwitchToMode "Normal"; }
            bind "k" { MoveFocus "Up"; SwitchToMode "Normal"; }
            bind "o" { FocusNextPane; }
            bind "d" { Detach; }
            bind "Space" { NextSwapLayout; }
            bind "x" { CloseFocus; SwitchToMode "Normal"; }
          }
          shared_except "locked" {
            bind "Alt g" { SwitchToMode "Locked"; }
            bind "Alt q" { Quit; }
            bind "Alt f" { ToggleFloatingPanes; }
            bind "Alt n" { NewPane; }
            bind "Alt i" { MoveTab "Left"; }
            bind "Alt o" { MoveTab "Right"; }
            bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
            bind "Alt l" "Alt Right" { MoveFocusOrTab "Right"; }
            bind "Alt j" "Alt Down" { MoveFocus "Down"; }
            bind "Alt k" "Alt Up" { MoveFocus "Up"; }
            bind "Alt =" "Alt +" { Resize "Increase"; }
            bind "Alt -" { Resize "Decrease"; }
            bind "Alt [" { PreviousSwapLayout; }
            bind "Alt ]" { NextSwapLayout; }
            bind "Alt p" { TogglePaneInGroup; }
            bind "Alt Shift p" { ToggleGroupMarking; }
          }
          shared_except "normal" "locked" {
            bind "Enter" "Esc" { SwitchToMode "Normal"; }
          }
          shared_except "pane" "locked" {
            bind "Alt p" { SwitchToMode "Pane"; }
          }
          shared_except "resize" "locked" {
            bind "Alt r" { SwitchToMode "Resize"; }
          }
          shared_except "scroll" "locked" {
            bind "Alt s" { SwitchToMode "Scroll"; }
          }
          shared_except "session" "locked" {
            bind "Alt o" { SwitchToMode "Session"; }
          }
          shared_except "tab" "locked" {
            bind "Alt t" { SwitchToMode "Tab"; }
          }
          shared_except "move" "locked" {
            bind "Alt m" { SwitchToMode "Move"; }
          }
          shared_except "tmux" "locked" {
            bind "Alt b" { SwitchToMode "Tmux"; }
          }
        }
      '';
    };
  };
}
