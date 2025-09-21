{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.custom.vscode.enable {
    programs.vscode.enable = true;
    programs.vscode.profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        vspacecode.whichkey
        alefragnani.project-manager
        arcticicestudio.nord-visual-studio-code
      ];
      userSettings = {
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 700;
        "workbench.colorTheme" = "Nord";
        "editor.minimap.enabled" = false;
        "workbench.statusBar.visible" = false;
        "workbench.editor.editorActionsLocation" = "hidden";
        "workbench.editor.showTabs" = "none";
        "workbench.activityBar.location" = "hidden";
        "editor.fontSize" = 13;
        "editor.fontFamily" = "JetBrains Mono";
        "editor.fontLigatures" = true;
        "editor.cursorStyle" = "block";
        "editor.cursorBlinking" = "solid";
        "editor.smoothScrolling" = true;
        "editor.cursorSmoothCaretAnimation" = "on";
        "terminal.integrated.fontSize" = 13;
        "terminal.integrated.fontFamily" = "JetBrains Mono";
        "terminal.integrated.sendKeybindingsToShell" = true;
        "projectManager.git.baseFolders" = [ "~/dev" ];
        "vim.showMarksInGutter" = true;
        "vim.smartRelativeLine" = true;
        "vim.cursorStylePerMode.normal" = "underline-thin";
        "vim.cursorStylePerMode.insert" = "line-thin";
        "vim.camelCaseMotion.enable" = true;
        "vim.useSystemClipboard" = true;
        "vim.leader" = ";";
        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            before = [ "," ];
            commands = [ "whichkey.show" ];
          }
        ];
      };
      keybindings = [
        {
          key = "cmd+t";
          command = "-workbench.action.showAllSymbols";
        }
        {
          key = "cmd+t";
          command = "workbench.action.terminal.toggleTerminal";
          when = "terminal.active";
        }
        {
          key = "ctrl+`";
          command = "-workbench.action.terminal.toggleTerminal";
          when = "terminal.active";
        }
        {
          key = "shift+cmd+e";
          command = "-workbench.view.explorer";
          when = "viewContainer.workbench.view.explorer.enabled";
        }
        {
          key = "cmd+f";
          command = "-actions.find";
          when = "editorFocus || editorIsOpen";
        }
        {
          key = "cmd+f";
          command = "-settings.action.search";
          when = "inSettingsEditor";
        }
        {
          key = "cmd+f";
          command = "-repl.action.filter";
          when = "inDebugRepl && textInputFocus";
        }
        {
          key = "cmd+f";
          command = "-workbench.action.terminal.focusFind";
          when = "terminalFindFocused && terminalHasBeenCreated || terminalFindFocused && terminalProcessSupported || terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
        }
        {
          key = "cmd+f";
          command = "-editor.action.extensioneditor.showfind";
          when = "!editorFocus && activeEditor == 'workbench.editor.extension'";
        }
        {
          key = "cmd+f";
          command = "-editor.action.webvieweditor.showFind";
          when = "webviewFindWidgetEnabled && !editorFocus && activeEditor == 'WebviewEditor'";
        }
        {
          key = "cmd+f";
          command = "-keybindings.editor.searchKeybindings";
          when = "inKeybindings";
        }
        {
          key = "cmd+f";
          command = "-list.find";
          when = "listFocus && listSupportsFind";
        }
        {
          key = "cmd+f";
          command = "-notebook.find";
          when = "notebookEditorFocused && !editorFocus && activeEditor == 'workbench.editor.notebook'";
        }
        {
          key = "cmd+f";
          command = "-problems.action.focusFilter";
          when = "focusedView == 'workbench.panel.markers.view'";
        }
        {
          key = "ctrl+enter";
          command = "-explorer.openToSide";
          when = "explorerViewletFocus && explorerViewletVisible && !inputFocus";
        }
        {
          key = "cmd+,";
          command = "workbench.action.showCommands";
        }
        {
          key = "shift+cmd+p";
          command = "-workbench.action.showCommands";
        }
        {
          key = "shift+cmd+p";
          command = "projectManager.listProjects";
        }
        {
          key = "alt+cmd+p";
          command = "-projectManager.listProjects";
        }
        {
          key = "cmd+f";
          command = "workbench.files.action.focusFilesExplorer";
          when = "!sideBarVisible || !filesExplorerFocus";
        }
        {
          key = "k";
          command = "list.focusUp";
          when = "listFocus && !inputFocus";
        }
        {
          key = "j";
          command = "list.focusDown";
          when = "listFocus && !inputFocus";
        }
        {
          key = "shift+j";
          command = "list.expand";
          when = "listFocus && treeElementCanExpand && !inputFocus || listFocus && treeElementHasChild && !inputFocus";
        }
        {
          key = "right";
          command = "-list.expand";
          when = "listFocus && treeElementCanExpand && !inputFocus || listFocus && treeElementHasChild && !inputFocus";
        }
        {
          key = "shift+j";
          command = "nextCompressedFolder";
          when = "explorerViewletCompressedFocus && explorerViewletVisible && filesExplorerFocus && !explorerViewletCompressedLastFocus && !inputFocus";
        }
        {
          key = "shift+k";
          command = "previousCompressedFolder";
          when = "explorerViewletCompressedFocus && explorerViewletVisible && filesExplorerFocus && !explorerViewletCompressedFirstFocus && !inputFocus";
        }
        {
          key = "shift+k";
          command = "list.collapse";
          when = "listFocus && treeElementCanCollapse && !inputFocus || listFocus && treeElementHasParent && !inputFocus";
        }
        {
          key = "r";
          command = "renameFile";
          when = "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
        }
        {
          key = "enter";
          command = "-renameFile";
          when = "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
        }
        {
          key = "cmd+f";
          command = "workbench.action.toggleSidebarVisibility";
          when = "sideBarVisible && filesExplorerFocus";
        }
        {
          key = "cmd+b";
          command = "-workbench.action.toggleSidebarVisibility";
        }
        {
          key = "cmd+r";
          command = "workbench.action.debug.run";
          when = "debuggersAvailable && debugState != 'initializing'";
        }
        {
          key = "ctrl+f5";
          command = "-workbench.action.debug.run";
          when = "debuggersAvailable && debugState != 'initializing'";
        }
        {
          key = "cmd+r";
          command = "-workbench.action.reloadWindow";
          when = "isDevelopment";
        }
        {
          key = "ctrl+shift+l";
          command = "workbench.action.nextEditor";
        }
        {
          key = "ctrl+cmd+h";
          command = "workbench.action.previousEditor";
        }
        {
          key = "alt+cmd+right";
          command = "-workbench.action.nextEditor";
        }
        {
          key = "ctrl+cmd+l";
          command = "workbench.action.nextEditor";
        }
        {
          key = "ctrl+shift+g";
          command = "-workbench.view.scm";
          when = "workbench.scm.active";
        }
        {
          key = "cmd+2";
          command = "workbench.action.showAllSymbols";
        }
        {
          key = "f13";
          command = "workbench.action.showAllSymbols";
        }
        {
          key = "m n";
          command = "explorer.newFile";
          when = "filesExplorerFocus && !inputFocus";
        }
        {
          key = "m shift+n";
          command = "explorer.newFolder";
          when = "filesExplorerFocus && !inputFocus";
        }
        {
          key = "tab";
          command = "extension.vim_tab";
          when = "editorFocus && vim.active && !inDebugRepl && vim.mode != 'Insert' && editorLangId != 'magit'";
        }
        {
          key = "tab";
          command = "-extension.vim_tab";
          when = "editorFocus && vim.active && !inDebugRepl && vim.mode != 'Insert'";
        }
      ];
    };
  };
}
