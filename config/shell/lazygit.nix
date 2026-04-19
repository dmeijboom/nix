{
  ...
}:
{
  programs.lazygit = {
    enable = true;
    settings = {
      customCommands = [
        {
          key = "s";
          context = "files";
          command = "git stash -u -- {{.SelectedFile.Name | quote}}";
        }
        {
          key = "B";
          context = "files";
          prompts = [
            {
              type = "menu";
              title = "What kind of commit/branch?";
              key = "BranchType";
              options = [
                {
                  name = "feature";
                  value = "feat";
                }
                {
                  name = "hotfix";
                  value = "fix";
                }
                {
                  name = "refactor";
                  value = "refactor";
                }
              ];
            }
            {
              type = "input";
              title = "Commit message?";
              key = "Message";
              initialValue = "";
            }
          ];
          command = "git checkout -b {{ .Form.BranchType }}/$(echo {{ .Form.Message | quote }} | sed 's/[ \\(\\)@]/-/g' | tr '[:upper:]' '[:lower:]') && git commit -m '{{ .Form.BranchType }}: {{ .Form.Message }}'";
        }
      ];
      promptToReturnFromSubprocess = false;
      git.pagers = [
        {
          useExternalDiffGitConfig = true;
        }
      ];
      git.autoFetch = false;
      gui.statusPanelView = "allBranchesLog";
      gui.authorColors = {
        "*" = "#B48EAD";
      };
      gui.showRandomTip = false;
      gui.showCommandLog = false;
      gui.showPanelJumps = false;
      gui.screenMode = "half";
      gui.theme = {
        activeBorderColor = [
          "#81A1C1"
          "bold"
        ];
        inactiveBorderColor = [ "#3B4252" ];
        optionsTextColor = [ "#88C0D0" ];
        selectedLineBgColor = [ "#3B4252" ];
        cherryPickedCommitBgColor = [ "#434C5E" ];
        cherryPickedCommitFgColor = [ "#88C0D0" ];
        unstagedChangesColor = [ "#BF616A" ];
        defaultFgColor = [ "#D8DEE9" ];
        searchingActiveBorderColor = [ "#EBCB8B" ];
      };
    };
  };
}
