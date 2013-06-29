
on getScreens()
  set tmp to do shell script "PWD"
  set myPath to POSIX path of (path to me) as string
  set dirname to (do shell script "dirname " & myPath) as string
  
  set scrString to do shell script dirname & "/screens"
  set scrRes to explode(",", scrString)

  return scrRes
end getScreens

on getDisplayBounds()
  --TODO: multi monitor support
  set scrRes to getScreens()
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

