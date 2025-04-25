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

  # Shell config
  programs.zsh = {
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

  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.starship.settings = {
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

  programs.rio.enable = true;
  programs.rio.settings = {
    theme = "nord";
    cursor = {
      shape = "underline";
      blinking = false;
    };
  };

  # Git config
  programs.git = {
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
  
  programs.lazygit.enable = true;
  programs.lazygit.settings = {
    git.paging.pager = "delta --dark --paging=never";
    git.autoFetch = false;
    gui.statusPanelView = "allBranchesLog";
  };
}
