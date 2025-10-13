{
  pkgs,
  ...
}:
let
  serialize =
    value:
    if builtins.isString value then
      ''"${value}"''
    else if builtins.isInt value then
      builtins.toString value
    else if builtins.isFloat value then
      builtins.toString value
    else if builtins.isBool value then
      if value then "true" else "false"
    else if builtins.isList value then
      "{ " + (builtins.concatStringsSep ", " (map serialize value)) + " }"
    else if builtins.isAttrs value then
      if value ? _raw then
        value._raw
      else
        "{ "
        + (builtins.concatStringsSep ", " (
          builtins.attrValues (builtins.mapAttrs (k: v: "['${k}'] = ${serialize v}") value)
        ))
        + " }"
    else
      throw "unknown type: ${builtins.typeOf value}";

  mkPlugin = (
    config: {
      pluginName = config.name;
      config = serialize (
        removeAttrs config [
          "name"
          "src"
        ]
      );
      setup = (
        name:
        if builtins.hasAttr "src" config then
          pkgs.vimUtils.buildVimPlugin {
            name = config.name;
            src = config.src;
          }
        else
          pkgs.vimPlugins.${name}
      );
    }
  );
in
{
  mkPlugin = mkPlugin;
}
