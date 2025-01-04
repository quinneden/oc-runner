{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.zsh.pure-prompt;
in
with lib;
{
  meta.maintainers = [ maintainers.quinneden ];

  options.programs.zsh.pure-prompt = {
    enable = mkEnableOption "Pretty, minimal and fast ZSH prompt";
    package = mkPackageOption pkgs "pure-prompt" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs.zsh.promptInit = ''
      fpath+=(${cfg.package}/share/zsh/site-functions)
      autoload -U promptinit; promptinit
      prompt pure
    '';
  };
}
