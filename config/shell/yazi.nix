{
  pkgs,
  lib,
  ...
}:
let
  plugins = [
    "no-status"
    "git"
    "full-border"
  ];

  # Generate the attrset for programs.yazi.plugins
  pluginAttrs = lib.listToAttrs (
    map (name: {
      inherit name;
      value = pkgs.yaziPlugins.${name};
    }) plugins
  );

  # Generate the initLua requires
  pluginInits = lib.concatMapStringsSep "\n" (name: ''require("${name}"):setup()'') plugins;
in
{
  programs.yazi = {
    enable = true;
    settings = {
      mgr = {
        show_symlink = false;
        show_hidden = true;
      };
      plugin.prepend_fetchers = [
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
    };
    plugins = pluginAttrs;
    initLua = pluginInits;
    theme = {
      mgr = {
        border_style.fg = "#363b48";
        hovered.bg = "#4e5668";
      };
    };
  };
}
