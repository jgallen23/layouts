
on run argv

  set theApp to (path to frontmost application as Unicode text)
  set screenBounds to getDisplayBounds()

  set theLayoutKey to item 1 of argv

  if theLayoutKey is "test" then
    testLayouts(theApp, screenBounds)
  else
    set layouts to makeDefaultLayouts()
    set layout to findLayout(layouts, theLayoutKey)
    resize(theApp, screenBounds, layout)
  end if



end run
