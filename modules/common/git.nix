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
        make-dropbox-remote = ''
          !f() (
            TOP=$(git rev-parse --show-toplevel) || exit 1
            BASENAME="$(basename "$TOP")"
            TARGET="/Users/reinoud/Dropbox/backup/$BASENAME"
            BUNDLE_NAME="$TARGET/$BASENAME.bundle"
            if test -e "$TARGET"; then
              echo "Target $TARGET already exists, exiting" >&2
              exit 1
            fi
            mkdir "$TARGET" && \
            git create-bundle-remote "$BUNDLE_NAME" || { rmdir "$TARGET" 2>/dev/null; exit 1; }
          ); f'';
        create-bundle-remote = ''
          !f() (
            if test "$2" != ""; then
              echo "create-bundle-remote only takes a single parameter, the bundle filename" >&2
              exit 1
            fi
            if test "$(git remote)" != ""; then
              echo "Already has a remote: $(git remote -v)" >&2
              exit 1
            fi
            git bundle create "$1" --branches --tags &&
            git remote add origin "$1" &&
            git fetch origin &&
            git remote -v
          ); f'';
        cbr = "create-bundle-remote";
        get-remote-bundle-name = ''
          !f() (
            url=$(git remote get-url origin) &&
            [ -f "$url" ] &&
            head -n1 "$url" | grep -qE '^# v[23] git bundle$' &&
            echo "$url"
          ); f'';
        update-bundle-remote = ''
          !f() (
            BUNDLE_NAME="$(git get-remote-bundle-name)"
            if test "$BUNDLE_NAME" = ""; then
              echo "Repo does not seem to have a bundle remote on origin" >&2
              exit 1
            fi
            NEW_BUNDLE_NAME="$(mktemp -u "$BUNDLE_NAME.XXXXXXXXXXXXXX")" &&
            OLD_BUNDLE_NAME="$BUNDLE_NAME.bak.$(TZ=UTC date +%Y-%m-%dT%H.%M.%SZ)" &&
            git bundle create "$NEW_BUNDLE_NAME" --branches --tags && cp "$BUNDLE_NAME" "$OLD_BUNDLE_NAME" && mv "$NEW_BUNDLE_NAME" "$BUNDLE_NAME" &&
            git fetch origin
          ); f'';
        ubr = "update-bundle-remote";
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
