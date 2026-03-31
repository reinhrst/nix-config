{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "yy";
    settings = {
      plugin.prepend_fetchers = [
        {id = "git"; name = "*"; run = "git"; }
        {id = "git"; name = "*/"; run = "git"; }
      ];
    };
    initLua = ''
    th.git = th.git or {}
    th.git.added_sign = "A"
    th.git.modified_sign = "M"
    th.git.deleted_sign = "D"
    th.git.untracked_sign = "?"
    th.git.ignored_sign = "I"
    th.git.updated_sign = "U"
    require("git"):setup()
    require("folder-rules"):setup()
    '';
    keymap = {
      mgr.prepend_keymap = [
        { run = "plugin smart-enter"; on = [ "<Enter>" ]; desc = "Open file or enter directory";}
        { run = ''shell --block -- git d "$@"''; on = [ "g" "d" ]; desc = "Git diff";}
        { run = ''shell --block -- git dc "$@"''; on = [ "g" "c" ]; desc = "Git diff --cached";}
        { run = ''shell --block -- git s''; on = [ "g" "s" ]; desc = "Git status";}
      ];
    };
    plugins = {
      git = pkgs.yaziPlugins.git;
      smart-enter = pkgs.yaziPlugins.smart-enter;
      folder-rules = pkgs.writeTextDir "main.lua" ''
        local function setup()
          ps.sub("cd", function()
            local cwd = cx.active.current.cwd
            if cwd:ends_with("Downloads") then
              ya.emit("sort", { "btime", reverse = true, dir_first = false })
            else
              ya.emit("sort", { "alphabetical", reverse = false, dir_first = true })
            end
          end)
        end

        return { setup = setup }
      '';
    };
  };
}
