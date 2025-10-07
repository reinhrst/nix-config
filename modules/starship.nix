{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      add_newline = true;

      format = "[╭](blue) $directory[](fg:#2C465A bg:#4E533B)$git_branch[](fg:#4E533B bg:#9EA33B)$git_status$git_state$fill $cmd_duration$status[╮](blue) \n[╰](blue) $character";

      right_format = "$time [╯](blue)";

      package.disabled = true;

      directory = {
        repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style)";
        truncation_length = 9;
        style = "bg:#2C465A fg:blue";
        fish_style_pwd_dir_length = 1;
        truncation_symbol = "../";
        repo_root_style = "bg:#2C465A fg:blue bold";
        before_repo_root_style = "bg:#2C465A fg:#566B7B";
      };

      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style)";
        symbol = " ";
        style = "bg:#4E533B fg:green";
      };

      git_status = {
        style = "bg:#9EA33B fg:yellow";
        conflicted = "\${count}=";
        stashed = "\${count}$";
        staged = "\${count}+";
        modified = "\${count}!";
        renamed = "\${count}»";
        deleted = "\${count}✘";
        untracked = "\${count}?";
        up_to_date = "✓";
        ahead = "\${count}⇡";
        behind = "\${count}⇣";
        diverged = "\${ahead_count}⇡\${behind_count}⇣";
      };

      git_state.style = "bg:#9EA33B fg:yellow";

      fill = {
        symbol = "─";
        style = "blue";
      };

      cmd_duration = {
        min_time = 0;
      };

      status = {
        disabled = false;
        success_symbol = "✓";
        format = "[$symbol$int]($style) ";
        recognize_signal_code = true;
        map_symbol = true;
        pipestatus = true;
        pipestatus_separator = "|";
        pipestatus_format = "\\[$pipestatus\\] => [$symbol$int]($style) ";
        style = "bold red";
        success_style = "bold green";
      };

      time = {
        disabled = false;
        format = "[$time]($style)";
      };
    };
  };
}
