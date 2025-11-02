{ config, pkgs, ... }:

let
  # Custom tmux recovery script (launches Ghostty with plain zsh, no default tmux)
  ghosttyRecoveryScript = pkgs.writeShellApplication {
    name = "ghostty-tmux-recovery";
    text = ''
      #!/usr/bin/env zsh
      exec /Applications/Ghostty.app/Contents/MacOS/ghostty -e /etc/profiles/per-user/reinoud/bin/zsh
    '';
    runtimeInputs = [ pkgs.zsh ];
  };

  # Bundle as macOS .app for icon/launcher
  ghosttyRecoveryApp = pkgs.stdenv.mkDerivation {
    name = "Ghostty-Tmux-Recovery.app";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/Applications/Ghostty-Tmux-Recovery.app/Contents/{MacOS,Resources}

      # Info.plist for .app metadata
      cat > $out/Applications/Ghostty-Tmux-Recovery.app/Contents/Info.plist <<EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>ghostty-tmux-recovery</string>
        <key>CFBundleIdentifier</key>
        <string>com.user.ghostty.tmuxrecovery</string>
        <key>CFBundleName</key>
        <string>Ghostty Tmux Recovery</string>
        <key>CFBundleIconFile</key>
        <string>ghostty.icns</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleVersion</key>
        <string>1.0</string>
      </dict>
      </plist>
      EOF

      # AppleScript launcher (runs the shell script)
      cat > $out/Applications/Ghostty-Tmux-Recovery.app/Contents/MacOS/ghostty-tmux-recovery <<EOF
      #!/usr/bin/env osascript
      do shell script "${ghosttyRecoveryScript}/bin/ghostty-tmux-recovery"
      EOF
      chmod +x $out/Applications/Ghostty-Tmux-Recovery.app/Contents/MacOS/ghostty-tmux-recovery

      # Symlink script for direct use
      mkdir -p $out/bin
      ln -s ${ghosttyRecoveryScript}/bin/ghostty-tmux-recovery $out/bin/ghostty-tmux-recovery

      # Reuse Ghostty icon if available
      if [ -f "/Applications/Ghostty.app/Contents/Resources/ghostty.icns" ]; then
        ln -s /Applications/Ghostty.app/Contents/Resources/ghostty.icns $out/Applications/Ghostty-Tmux-Recovery.app/Contents/Resources/
      fi
    '';
  };
in
{
  # Existing Ghostty configuration (unchanged)
  xdg.configFile."ghostty/config".text = ''
    # Start tmux by default
    command = ${pkgs.zsh}/bin/zsh -lc ${pkgs.tmux}/bin/tmux new-session -A -s main

    theme = Snazzy

    # Font configuration
    font-family = "JetBrainsMono Nerd Font"
    font-size = 12
    font-feature = -calt, -liga, -dlig

    # Window management (send Option sequences for tmux)
    keybind = super+t=text:\x1bt
    keybind = super+shift+t=text:\x1bT
    keybind = super+shift+left_bracket=text:\x1b{
    keybind = super+shift+right_bracket=text:\x1b}
    keybind = super+shift+left=text:\x1b[1;7D
    keybind = super+shift+right=text:\x1b[1;7C

    # Scrolling
    keybind = super+up=text:\x1b[1;3A
    keybind = super+down=text:\x1b[1;3B
    keybind = super+shift+up=text:\x1b[1;7A
    keybind = super+shift+down=text:\x1b[1;7B

    # Copy/paste
    keybind = super+shift+a=text:\x1bA
    keybind = super+c=text:\x1bc

    # Window selection
    keybind = super+one=text:\x1b1
    keybind = super+two=text:\x1b2
    keybind = super+three=text:\x1b3
    keybind = super+four=text:\x1b4
    keybind = super+five=text:\x1b5
    keybind = super+six=text:\x1b6
    keybind = super+seven=text:\x1b7
    keybind = super+eight=text:\x1b8
    keybind = super+nine=text:\x1b9

    keybind = super+enter=text:\x1b\r
  '';

  # Add the custom launcher to home.packages (via module output)
  home.packages = [
    ghosttyRecoveryScript
    ghosttyRecoveryApp
  ];

  # Activation to symlink .app to ~/Applications for easy access
  home.activation.symlinkGhosttyRecoveryApp = config.lib.dag.entryAfter ["writeBoundary"] ''
    APP_PATH="${ghosttyRecoveryApp}/Applications/Ghostty-Tmux-Recovery.app"
    TARGET="$HOME/Applications/Ghostty-Tmux-Recovery.app"
    if [ -L "$TARGET" ] || [ -e "$TARGET" ]; then
      rm -f "$TARGET"
    fi
    ln -s "$APP_PATH" "$TARGET"
    echo "Symlinked Ghostty Tmux Recovery app to $TARGET"
  '';
}
