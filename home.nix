{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.kubie
    pkgs.mirrord
  ];
  home.shellAliases = {
    s = "lazygit";
  };
  home.stateVersion = "23.11";

  programs = {
    # Shell config
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      history = {
        share = true;
        append = true;
        extended = true;
        ignoreDups = true;
        size = 10000000;
        save = 10000000;
      };
      initContent = ''
        export EDITOR="zed --wait"
      '';
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    starship.enable = true;
    starship.enableZshIntegration = true;
    starship.settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
        vicmd_symbol = "[V](bold green)";
      };
      aws = { disabled = true; };
      gcloud = { disabled = true; };
      kubernetes = { disabled = false; };
      docker_context = { disabled = true; };
    };

    rio.enable = true;
    rio.settings = {
      theme = "nord";
      cursor = {
        shape = "underline";
        blinking = false;
      };
    };

    # Git config
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
        push = { autoSetupRemote = true; };
        pull = { ff = "only"; };
      };
      ignores = [
        ".envrc"
        "/flake.lock"
        "/flake.nix"
        ".zed/tasks.json"
      ];
    };

    lazygit.enable = true;
    lazygit.settings = {
      git.paging.pager = "delta --dark --paging=never";
      git.autoFetch = false;
      gui.statusPanelView = "allBranchesLog";
      gui.authorColors = { "*" = "#b7bdf8"; };
      gui.showRandomTip = false;
      gui.showCommandLog = false;
      gui.showPanelJumps = false;
      gui.theme = {
        activeBorderColor = [
          "#8aadf4"
          "bold"
        ];
        inactiveBorderColor = ["#a5adcb"];
        optionsTextColor = ["#8aadf4"];
        selectedLineBgColor = ["#363a4f"];
        cherryPickedCommitBgColor = ["#494d64"];
        cherryPickedCommitFgColor = ["#8aadf4"];
        unstagedChangesColor = ["#ed8796"];
        defaultFgColor = ["#cad3f5"];
        searchingActiveBorderColor = ["#eed49f"];
      };
    };
  };
}
