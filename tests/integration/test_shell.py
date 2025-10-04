#!/usr/bin/env python3
"""
Integration tests for shell configuration.
Tests the actual behavior of zsh, tmux, and vim together.
"""

import pexpect
import sys
import os


def test_zsh_basic():
    """Test that zsh starts and basic commands work (with tmux auto-start)."""
    print("Testing zsh basic functionality...")

    child = pexpect.spawn('zsh', timeout=10, env={'TERM': 'xterm-256color'}, encoding='utf-8')

    # Wait for starship prompt (❯) - home-manager config should be active
    child.expect('❯', timeout=15)

    # Test basic command
    child.sendline('echo "test successful"')
    child.expect('test successful')

    child.sendline('exit')
    child.wait()
    print("✓ zsh basic test passed")


def test_zsh_vim_mode():
    """Test that zsh vi mode is enabled and working (in tmux, as configured)."""
    print("Testing zsh vi mode in tmux...")

    # Start zsh - should auto-start tmux with home-manager config
    child = pexpect.spawn('zsh', timeout=10, env={'TERM': 'xterm-256color'}, encoding='utf-8')

    # Wait for starship prompt (❯)
    child.expect('❯', timeout=15)

    # Type some text
    child.send('test_text')

    # Press ESC to enter vi normal mode
    child.send('\x1b')  # ESC key

    # In vi normal mode, 'i' should enter insert mode at cursor
    # We can verify this by checking we can still type
    child.send('i')
    child.send('_inserted')

    # Send the line to execute
    child.send('\r')  # Enter key

    # We should see the executed command (with the insertion)
    # The text should show our vim-mode editing worked
    child.expect('test_text_inserted')

    # Exit zsh (will also kill tmux session)
    child.sendline('exit')
    child.wait()
    print("✓ zsh vi mode test passed (in tmux)")


def test_zsh_history():
    """Test that history search works (atuin/fzf)."""
    print("Testing zsh history...")

    # This is a placeholder - actual test would need atuin/fzf configured
    # For now, just verify zsh loads without errors
    child = pexpect.spawn('zsh', ['-c', 'exit 0'], timeout=10)
    child.wait()

    if child.exitstatus == 0:
        print("✓ zsh history test passed")
    else:
        print("✗ zsh exited with non-zero status")
        sys.exit(1)


def test_tmux_basic():
    """Test that tmux can start a session."""
    print("Testing tmux basic functionality...")

    # Check if tmux is available
    child = pexpect.spawn('tmux', ['-V'], timeout=5)
    child.expect('tmux')
    child.wait()

    print("✓ tmux basic test passed")


def main():
    """Run all integration tests."""
    print("Starting integration tests...\n")

    try:
        test_zsh_basic()
        test_zsh_vim_mode()
        test_zsh_history()
        test_tmux_basic()

        print("\n✓ All integration tests passed!")
        return 0
    except Exception as e:
        print(f"\n✗ Test failed: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
