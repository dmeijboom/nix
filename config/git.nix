{ lib, config, pkgs, ... }:
{
  home.shellAliases.s = "lazygit";

  programs = {
    git = {
      enable = true;
      delta.enable = true;
      lfs.enable = true;
      signing = {
        format = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3qdw1DknYTEUeIuyRqCitz/Mqo5m1+a0g8/KdfQ2wr";
        signByDefault = true;
      } // lib.optionalAttrs pkgs.stdenv.isDarwin {
        signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      userName = "Dillen Meijboom";
      userEmail = "dillen@brainhive.nl";
      extraConfig = {
        push = {
          autoSetupRemote = true;
        };
        pull = {
          ff = "only";
        };
      };
      ignores = [
        ".env"
        ".dev"
        ".direnv"
        ".zed/tasks.json"
      ];
    };

    lazygit.enable = true;
    lazygit.settings = {
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
      git.paging.pager = "delta --dark --paging=never";
      git.autoFetch = false;
      gui.statusPanelView = "allBranchesLog";
      gui.authorColors = {
        "*" = "#b7bdf8";
      };
      gui.showRandomTip = false;
      gui.showCommandLog = false;
      gui.showPanelJumps = false;
      gui.screenMode = "half";
      gui.theme = {
        activeBorderColor = [
          "#8aadf4"
          "bold"
        ];
        inactiveBorderColor = [ "#a5adcb" ];
        optionsTextColor = [ "#8aadf4" ];
        selectedLineBgColor = [ "#363a4f" ];
        cherryPickedCommitBgColor = [ "#494d64" ];
        cherryPickedCommitFgColor = [ "#8aadf4" ];
        unstagedChangesColor = [ "#ed8796" ];
        defaultFgColor = [ "#cad3f5" ];
        searchingActiveBorderColor = [ "#eed49f" ];
      };
    };
  };
}
