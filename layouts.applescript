-- v0.0.2
on resize(loc)
	set perc to 0.9
	tell application "Finder"
		set _b to bounds of window of desktop
		set w to item 3 of _b
		set h to item 4 of _b
	end tell
	
	set front_app to (path to frontmost application as Unicode text)
	tell application front_app
		activate
		if loc contains "tr" then
			set bounds of window 1 to {(w / 2), 0, w, (h / 2)}
		else if loc contains "tl" then
			set bounds of window 1 to {0, 0, (w / 2), (h / 2)}
		else if loc contains "bl" then
			set bounds of window 1 to {0, (h / 2), (w / 2), h}
		else if loc contains "br" then
			set bounds of window 1 to {{w / 2, (h / 2), w, h}}
		else if loc contains "t" then
			set bounds of window 1 to {0, 0, w, (h / 2)}
		else if loc contains "r" then
			set bounds of window 1 to {(w / 2), 0, w, h}
		else if loc contains "l" then
			set bounds of window 1 to {0, 0, (w / 2), h}
		else if loc contains "b" then
			set bounds of window 1 to {0, (h / 2), w, h}
		else if loc contains "c" then
			set newW to w * perc
			set newH to h * perc
			set newX to (w * (1 - perc))
			set newY to (h * (1 - perc))
			set bounds of window 1 to {newX, newY, newW, newH}
		else
			set bounds of window 1 to {0, 0, w, h}
		end if
	end tell
end resize

on alfred_script(loc)
	resize(loc)
end alfred_script

--uncomment these lines to use for command line
--on run argv
--	resize(item 1 of argv)
--end run

--this can be changed to f,t,b,l,r,tl,tr,bl,br or c
--resize("c")
