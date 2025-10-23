{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.aider-chat ];

  home.file.".aider.conf.yml".text = ''
    alias:
      g4r: xai/grok-4-fast-reasoning
      g4n: xai/grok-4-fast-non-reasoning
      gc: xai/grok-code-fast-1
    vim: true
    auto-commits: false
    chat-mode: ask
    dark-mode: true
    show-diffs: true
    model: xai/grok-4-fast-reasoning
    editor-model: xai/grok-code-fast-1
    multiline: true
  '';
}
