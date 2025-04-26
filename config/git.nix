{ config, pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      delta.enable = true;
      lfs.enable = true;
      signing = {
        format = "ssh";
        signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3qdw1DknYTEUeIuyRqCitz/Mqo5m1+a0g8/KdfQ2wr";
        signByDefault = true;
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
        ".envrc"
        ".dev"
        ".direnv"
        ".zed/tasks.json"
      ];
    };

    lazygit.enable = true;
    lazygit.settings = {
      git.paging.pager = "delta --dark --paging=never";
      git.autoFetch = false;
      gui.statusPanelView = "allBranchesLog";
      gui.authorColors = {
        "*" = "#b7bdf8";
      };
      gui.showRandomTip = false;
      gui.showCommandLog = false;
      gui.showPanelJumps = false;
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
