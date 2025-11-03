{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    userName = "Claude";
    userEmail = "github@claude.nl";

    aliases = {
      c = "commit";
      co = "checkout";
      cp = "cherry-pick";
      d = "!if git rev-parse --is-inside-work-tree &>/dev/null; then git diff --color; else git diff --color 2>&1 | head -n 2 >&2 && false; fi";
      dc = "!if git rev-parse --is-inside-work-tree &>/dev/null; then git diff --color --cached; else git diff --color --cached 2>&1 | head -n 2 >&2 && false; fi";
      l = "log --pretty=format:'%h %s (%an -- %aI)%n' --decorate --stat --graph --color";
      pom = "push origin master";
      s = "status";
      up = "pull --rebase --autostash";
      p = ''!f(){ git push "$@" || printf '\e]9;Git push in "'$(pwd)'" failed\a'; };f'';
      cap = ''!f(){ (git commit "$@" && git push) || printf '\e]9;Git commit-and-push in "'$(pwd)'" failed\a'; };f'';
      cuap = ''!f(){ (git commit "$@" && git pull --rebase --autostash && git push) || printf '\e]9;Git commit-update-and-push in "'$(pwd)'" failed\a'; };f'';
      psuo = ''!f(){ (git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)";) };f'';
    };

    extraConfig = {
      apply = {};
      push = {
        default = "simple";
      };
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
      };
      uploadArchive = {
        allowUnreachable = true;
      };
      pull = {
        rebase = true;
      };
    };

    ignores = [
      ".DS_Store"
      "/.claude/settings.local.json"
      "/.aider*"
    ];
  };
}
