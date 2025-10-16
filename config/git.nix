{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.custom.mode == "client") {
    programs = {
      git = {
        enable = true;
        delta.enable = true;
        lfs.enable = true;
        signing = {
          format = "ssh";
          signByDefault = true;
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3qdw1DknYTEUeIuyRqCitz/Mqo5m1+a0g8/KdfQ2wr";
          signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        }
        // lib.optionalAttrs pkgs.stdenv.isLinux {
          key = "/home/${config.custom.username}/.ssh/signing_key.pub";
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
    };
  };
}
