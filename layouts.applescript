-- v0.0.4

on get_screens()
	set f to (path to preferences from local domain as Unicode text) & "com.apple.windowserver.plist"
	
	tell application "System Events"
		set v to value of property list item 1 of property list item "DisplaySets" of property list file f
		set {scrRes1, scrRes2} to {{|OriginX|, |OriginY|, |Width|, |Height|} of beginning of v, missing value}
		if ((count v) > 1) then set scrRes2 to {|OriginX|, |OriginY|, |Width|, |Height|} of item 2 of v -- Second screen.
	end tell
	return {scrRes1, scrRes2}
end get_screens

on is_inside(pnt, bounds)
	set x to item 1 of pnt
	set y to item 2 of pnt
	if x ≥ item 1 of bounds and x < item 3 of bounds and y ≥ item 2 of bounds and y < item 4 of bounds then
		return true
	else
		return false
	end if
end is_inside

on get_screen_bounds(app_bounds)
	set screens to my get_screens()
	set app_x to item 1 of app_bounds
	set app_y to item 2 of app_bounds
	set screen1 to item 1 of screens
	if my is_inside({app_x, app_y}, screen1) then
		return screen1
	else
		return item 2 of screens
	end if
end get_screen_bounds

on get_next_screen(screen_bounds)
	set screens to my get_screens()
	set screen1 to item 1 of screens
	
	if item 1 of screen_bounds = item 1 of screen1 and item 2 of screen_bounds = item 2 of screen1 then
		return item 2 of screens
	else
		return screen1
	end if
	
end get_next_screen

on resize(loc)
	set perc to 0.9
	
	set front_app to (path to frontmost application as Unicode text)
	tell application front_app
		set app_bounds to bounds of window 1
		set screen to my get_screen_bounds(app_bounds)
		set sx to item 1 of screen
		set sy to item 2 of screen
		set sw to item 3 of screen
		set sh to item 4 of screen
		activate
		if loc contains "tr" then
			set x to sx + sw / 2
			set y to sy
			set w to sw + sx
			set h to sy + sh / 2
		else if loc contains "tl" then
			set x to sx
			set y to sy
			set w to sx + sw / 2
			set h to sy + sh / 2
		else if loc contains "bl" then
			set x to sx
			set y to sy + sh / 2
			set w to sx + sw / 2
			set h to sy + sh
		else if loc contains "br" then
			set x to sx + sw / 2
			set y to sy + sh / 2
			set w to sx + sw
			set h to sy + sh
		else if loc contains "t" then
			set x to sx
			set y to sy
			set w to sx + sw
			set h to sy + sh / 2
		else if loc contains "r" then
			set x to sx + sw / 2
			set y to sy
			set w to sx + sw
			set h to sy + sh
		else if loc contains "l" then
			set x to sx
			set y to sy
			set w to sx + sw / 2
			set h to sy + sh
		else if loc contains "b" then
			set x to sx
			set y to sy + sh / 2
			set w to sx + sw
			set h to sy + sh
		else if loc contains "c" then
			set x to sx + sw * (1 - perc)
			set y to sy + sh * (1 - perc)
			set w to sx + sw * perc
			set h to sy + sh * perc
		else if loc contains "f" then
			set x to sx
			set y to sy
			set w to sx + sw
			set h to sy + sh
		else if loc contains "m" then
			set next_screen to my get_next_screen(screen)
			set app_width to (item 3 of app_bounds) - (item 1 of app_bounds)
			set app_height to (item 4 of app_bounds) - (item 2 of app_bounds)
			if app_width > ((item 3 of next_screen) - (item 1 of next_screen)) then
				set app_width to (item 3 of next_screen)
			end if
			if app_height > ((item 4 of next_screen) - (item 2 of next_screen)) then
				set app_height to (item 4 of next_screen)
			end if
			set nsx to item 1 of next_screen
			set nsy to item 2 of next_screen
			set x to nsx
			set y to nsy
			set w to nsx + app_width
			set h to nsy + app_height
		end if
		set bounds of window 1 to {x, y, w, h}
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
--resize("m")


