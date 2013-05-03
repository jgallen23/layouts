-- Layouts
-- v2.1.0
-- http://projects.jga.me/layouts
-- copyright JGA 2013
-- MIT License


on explode(delimiter, input)
  local delimiter, input, ASTID
  set ASTID to AppleScript's text item delimiters
  try
    set AppleScript's text item delimiters to delimiter
    set input to text items of input
    set AppleScript's text item delimiters to ASTID
    return input --> list
  on error eMsg number eNum
    set AppleScript's text item delimiters to ASTID
    error "Can't explode: " & eMsg number eNum
  end try
end explode


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


on makeLayout(_name, _key, x1, y1, x2, y2)
  script layout
    property theName : _name
    property theKey : _key
    property x1Percentage : x1
    property y1Percentage : y1
    property x2Percentage : x2
    property y2Percentage : y2
  end script
  return layout
end makeLayout

on makeDefaultLayouts()

  set topLeft to makeLayout("Top Left", "topleft", 0, 0, 0.5, 0.5)
  set topRight to makeLayout("Top Right", "topright", 0.5, 0, 1, 0.5)
  set bottomLeft to makeLayout("Bottom Left", "bottomleft", 0, 0.5, 0.5, 1)
  set bottomRight to makeLayout("Bottom Right", "bottomright", 0.5, 0.5, 1.0, 1)
  set top to makeLayout("Top", "top", 0, 0, 1, .5)
  set bottom to makeLayout("Bottom", "bottom", 0, .5, 1, 1)
  set _left to makeLayout("Left", "left", 0, 0, 0.5, 1)
  set _right to makeLayout("Right", "right", .5, 0, 1, 1)
  set zoom to makeLayout("Zoom", "zoom", 0, 0, 1, 1)
  set centerLarge to makeLayout("Center Large", "center", 0.1, 0.1, 0.9, 0.9)
  set centerSmall to makeLayout("Center Small", "centersmall", 0.3, 0.3, 0.7, 0.7)

  set layouts to { topLeft, topRight, bottomRight, bottomLeft, top, _right, bottom, _left, centerLarge, centerSmall, zoom }

  return layouts

end makeDefaultLayouts

on findLayout(layouts, layoutKey)

  set foundLayout to false
  repeat with layout in layouts
    set _key to get theKey of layout
    if layoutKey is _key then
      set foundLayout to layout
    end if
  end repeat
  return foundLayout

end findLayout

on resize(theApp, theScreenBounds, theLayout)

  tell application theApp
    set appBounds to bounds of window 1
    set sx to item 1 of theScreenBounds
    set sy to item 2 of theScreenBounds
    set sw to (item 3 of theScreenBounds) - sx
    set sh to (item 4 of theScreenBounds) - sy
    set x1 to sx + (sw * (x1Percentage of theLayout))
    set y1 to sy + (sh * (y1Percentage of theLayout))
    set x2 to sx + (sw * (x2Percentage of theLayout))
    set y2 to sy + (sh * (y2Percentage of theLayout))
    activate
    set bounds of window 1 to { x1, y1, x2, y2 }
  end tell
end resize

on testLayouts(theApp, screenBounds)
  set layouts to makeDefaultLayouts()
  repeat with layout in layouts
    resize(theApp, screenBounds, layout)
    delay 0.5
  end repeat
end testLayouts


on run argv

  set theApp to (path to frontmost application as Unicode text)
  set screenBounds to getDisplayBounds()

  set theLayoutKey to item 1 of argv

  if theLayoutKey is "test" then
    testLayouts(theApp, screenBounds)
  else
    set layouts to makeDefaultLayouts()
    set layout to findLayout(layouts, theLayoutKey)

    if layout is false then
      set sizes to explode(" ", theLayoutKey)
      set layout to makeLayout("Temp", "tmp", (item 1 of sizes), (item 2 of sizes), (item 3 of sizes), (item 4 of sizes))
    end if
    resize(theApp, screenBounds, layout)
  end if



end run
