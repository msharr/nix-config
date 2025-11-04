_: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      share = false;
    };
    initExtra = ''
      setopt HIST_FIND_NO_DUPS
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
    '';

    shellAliases = {
      la = "ls -la";
      ".." = "cd ..";
      "rebuild" = "sudo darwin-rebuild switch --flake ~/nix";
      "ds" = "NIXPKGS_ALLOW_INSECURE=1 nix develop --impure -c zsh";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➤](bold green)";
        error_symbol = "[✘](bold red)";
      };
      
      nix_shell = {
        disabled = true;
      };
      
      nodejs = {
        symbol = "";
        format = "[$version]($style) ";
      };
      rust = {
        symbol = "";
        format = "[$version]($style) ";
      };
      golang = {
        symbol = "";
        format = "[$version]($style) ";
      };
      python = {
        symbol = "";
        format = "[$version]($style) ";
      };
      java = {
        symbol = "";
        format = "[$version]($style) ";
      };
      php = {
        symbol = "";
        format = "[$version]($style) ";
      };
      ruby = {
        symbol = "";
        format = "[$version]($style) ";
      };
      elixir = {
        symbol = "";
        format = "[$version]($style) ";
      };
      swift = {
        symbol = "";
        format = "[$version]($style) ";
      };
      kotlin = {
        symbol = "";
        format = "[$version]($style) ";
      };
      lua = {
        symbol = "";
        format = "[$version]($style) ";
      };
      dart = {
        symbol = "";
        format = "[$version]($style) ";
      };
      deno = {
        symbol = "";
        format = "[$version]($style) ";
      };
      bun = {
        symbol = "";
        format = "[$version]($style) ";
      };
      git_branch = { symbol = ""; };
      package = { symbol = ""; };
      docker_context = { symbol = ""; };
      aws = { symbol = ""; };
      azure = { symbol = ""; };
      gcloud = { symbol = ""; };
      env_var = { symbol = ""; };
      memory_usage = { symbol = ""; };
      
      custom.nix_shell = {
        description = "Show snowflake when in nix develop shell";
        command = ''if [ -n "$IN_NIX_SHELL" ]; then echo "❄️"; fi'';
        when = ''[ -n "$IN_NIX_SHELL" ]'';
        format = "$output ";
        style = "cyan";
        disabled = false;
      };
    };
  };
}
