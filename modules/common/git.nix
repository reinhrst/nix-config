{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Claude";
        email = "github@claude.nl";
      };

      alias = {
        c = "commit";
        co = "checkout";
        cp = "cherry-pick";
        d = ''diff'';
        dc = ''diff --cached'';
        l = "log --pretty=format:'%h %s (%an -- %aI)%n' --decorate --stat --graph --color";
        pom = "push origin master";
        s = "status";
        up = "pull --rebase --autostash";
        p = ''!f(){ git push "$@" || printf '\e]9;Git push in "'$(pwd)'" failed\a'; };f'';
        cap = ''!f(){ (git commit "$@" && git push) || printf '\e]9;Git commit-and-push in "'$(pwd)'" failed\a'; };f'';
        cuap = ''!f(){ (git commit "$@" && git pull --rebase --autostash && git push) || printf '\e]9;Git commit-update-and-push in "'$(pwd)'" failed\a'; };f'';
        psuo = ''!f(){ (git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)";) };f'';
      };

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
    signing.format = null;

    ignores = [
      ".DS_Store"
      "/.claude/settings.local.json"
      "/.aider*"
    ];
  };
}
