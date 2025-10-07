{ config, pkgs, ... }:
let
  palette = {
    border = "blue";
    directoryBg  = "#2C465A";
    directoryFg  = "blue";
    beforeDirFg  = "#566B7B";
    branchBg     = "#4E533B";
    branchFg     = "green";
    gitStatusBg     = "#9EA33B";
    gitStatusFg     = "yellow";
    statusSuccessFg     = "green";
    statusFailFg     = "red";
  };
in
  {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      add_newline = true;

      format = "[╭](${palette.border}) $directory[](fg:${palette.directoryBg} bg:${palette.branchBg})$git_branch[](fg:${palette.branchBg} bg:${palette.gitStatusBg})$git_status$git_state$fill $cmd_duration$status[╮](${palette.border}) \n[╰](${palette.border}) $character";

      right_format = "$time [╯](${palette.border})";

      package.disabled = true;

      directory = {
        repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style)";
        truncation_length = 9;
        style = "bg:${palette.directoryBg} fg:${palette.directoryFg}";
        fish_style_pwd_dir_length = 1;
        truncation_symbol = "../";
        repo_root_style = "bg:${palette.directoryBg} fg:${palette.directoryFg} bold";
        before_repo_root_style = "bg:${palette.directoryBg} fg:${palette.beforeDirFg}";
      };

      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style)";
        symbol = " ";
        style = "bg:${palette.branchBg} fg:${palette.branchFg}";
      };

      git_status = {
        style = "bg:${palette.gitStatusBg} fg:${palette.gitStatusFg}";
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

      git_state.style = "bg:${palette.gitStatusBg} fg:${palette.gitStatusFg}";

      fill = {
        symbol = "─";
        style = "${palette.border}";
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
        style = "bold ${palette.statusFailFg}";
        success_style = "bold ${palette.statusSuccessFg}";
      };

      time = {
        disabled = false;
        format = "[$time]($style)";
      };
    };
  };
}
