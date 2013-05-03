
on getDisplayBounds()
  --TODO: multi monitor support
  tell application "Finder"
    set scrRes to bounds of window of desktop
  end tell
  tell application "System Events"
    tell dock preferences
      set dockProperties to get properties
    end tell

    if autohide of dockProperties is false then
      tell process "Dock"
        set dockDimensions to size in list 1
        set dockWidth to item 1 of dockDimensions
        set dockHeight to item 2 of dockDimensions
      end tell
      set screenEdge to screen edge of dockProperties
      if screenEdge is bottom then
        set item 4 of scrRes to (item 4 of scrRes) - dockHeight
      else if screenEdge is left then
        set item 1 of scrRes to dockWidth
        set item 4 of scrRes to (item 4 of scrRes) - dockWidth
      else if screenEdge is right then
        set item 3 of scrRes to (item 3 of scrRes) - dockWidth
      end if
    end if
  end tell

  return scrRes
end getDisplayBounds
