{
  pkgs,
  config,
  ...
}:
let
  shellAliases = {
    bs = "stat -c%s";
    cddf = "cd $dotdir";
    cddl = "cd ~/Downloads";
    code = "codium";
    db = "distrobox";
    gst = "git status";
    gsur = "git submodule update --init --recursive";
    l = "eza -la --group-directories-first";
    ll = "eza -glAh --octal-permissions --group-directories-first";
    ls = "eza -A";
    push = "git push";
    tree = "eza -ATL3 --git-ignore";
  };

in
{
  imports = [ ./pure-prompt.nix ];

  programs.zsh = {
    enable = true;
    pure-prompt.enable = true;
    shellAliases = shellAliases;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histFile = "${config.xdg.configHome}/zsh/.zsh_history";

    ohMyZsh = {
      enable = true;
      plugins = [
        "fzf"
        "eza"
        "zoxide"
        "direnv"
      ];
      custom = "${config.xdg.configHome}/zsh";
    };

    shellInit = ''
      fpath+=("${config.xdg.configHome}/zsh/completions")
      if type zoxide &>/dev/null; then eval "$(zoxide init zsh)"; fi
      if type z &>/dev/null; then alias cd='z'; fi
      for f ($HOME/.config/zsh/functions/*(N.)); do source $f; done
    '';
  };

  environment.sessionVariables = {
    compdir = "$HOME/.config/zsh/completions";
    dotdir = "$HOME/.dotfiles";
    EDITOR = "mi";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    MICRO_TRUECOLOR = "1";
    NIXOS_CONFIG = "$HOME/.dotfiles";
  };

  programs.bash = {
    enableCompletion = true;
    shellAliases = shellAliases;
    promptInit = ''
      PS1="\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\] \$ "
      export PS1
    '';
  };
}
