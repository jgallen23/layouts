
on getDisplayBounds()
  --TODO: multi monitor support
  tell application "Finder"
    set scrRes to bounds of window of desktop
  end tell
  return scrRes
end getDisplays
