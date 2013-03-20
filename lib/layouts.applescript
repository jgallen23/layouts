
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
