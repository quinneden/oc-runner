let
  shellAliases = {
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
    histFile = "$HOME/.config/zsh/.zsh_history";

    ohMyZsh = {
      enable = true;
      plugins = [
        "eza"
        "zoxide"
      ];
      custom = "$HOME/.config/zsh";
    };

    shellInit = ''
      if type zoxide &>/dev/null; then eval "$(zoxide init zsh)"; fi
      if type z &>/dev/null; then alias cd='z'; fi
      [[ -f $HOME/.hushlogin ]] || touch "$HOME"/.hushlogin
    '';
  };

  environment.sessionVariables = {
    EDITOR = "micro";
    ZDOTDIR = "$HOME/.config/zsh";
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
