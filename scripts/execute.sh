#!/bin/zsh

COMMAND_TO_RUN="${1:-echo Default command in Ghostty}"

osascript \
  -e 'on run argv' \
  -e '  set commandToType to item 1 of argv' \
  -e '  tell application "Ghostty"' \
  -e '    activate' \
  -e '    tell application "System Events"' \
  -e '      key code 17 using {command down}' \
  -e '      delay 0.5' \
  -e '    end tell' \
  -e '  end tell' \
  -e '  tell application "System Events"' \
  -e '    tell process "Ghostty"' \
  -e '      keystroke commandToType & "; exit"' \
  -e '      keystroke return' \
  -e '    end tell' \
  -e '  end tell' \
  -e 'end run' \
  -- "$COMMAND_TO_RUN"
