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

  tell application "System Events" to tell application process theApp
    set appBounds to get size of window 1
    set sx to item 1 of theScreenBounds
    set sy to item 2 of theScreenBounds
    set sw to (item 3 of theScreenBounds) - sx
    set sh to (item 4 of theScreenBounds) - sy
    set x1 to sx + (sw * (x1Percentage of theLayout))
    set y1 to sy + (sh * (y1Percentage of theLayout))
    set x2 to sx + (sw * (x2Percentage of theLayout))
    set y2 to sy + (sh * (y2Percentage of theLayout))
    activate
		try
			set bounds of window 1 to {x1, y1, x2, y2}
		on error
			tell window 1
				set {position, size} to {{x1, y1}, {x2, y2}}
			end tell
		end try
  end tell
end resize

on testLayouts(theApp, screenBounds)
  set layouts to makeDefaultLayouts()
  repeat with layout in layouts
    resize(theApp, screenBounds, layout)
    delay 0.5
  end repeat
end testLayouts
