{
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = true;
    settings.mgr.show_symlink = false;
    plugins = with pkgs.yaziPlugins; {
      inherit nord full-border;
    };
    flavors = { inherit (pkgs.yaziPlugins) nord; };
    theme.flavor = {
      light = "nord";
      dark = "nord";
    };
    initLua = ''
      require("nord"):setup()
      require("full-border"):setup()
    '';
  };
}
