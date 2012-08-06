-- v0.0.5

-- utilities
on splitString(theString, theDelimiter)
	-- save delimiters to restore old settings
	set oldDelimiters to AppleScript's text item delimiters
	-- set delimiters to delimiter to be used
	set AppleScript's text item delimiters to theDelimiter
	-- create the array
	set theArray to every text item of theString
	-- restore the old setting
	set AppleScript's text item delimiters to oldDelimiters
	-- return the result
	return theArray
end splitString

on joinList(someList, delimiter)
	set prevTIDs to AppleScript's text item delimiters
	set AppleScript's text item delimiters to delimiter
	set output to "" & someList
	set AppleScript's text item delimiters to prevTIDs
	return output
end joinList

global screens

on reset_screens()
	do shell script "defaults delete com.jga23.layouts screens"
	my get_screens()
end reset_screens

on get_screens()
	if screens is false then
		set scrRes1 to false
		set scrRes2 to false
		try
			set screenStr to do shell script "defaults read com.jga23.layouts screens"
			set screensSplit to my splitString(screenStr, "|")
			set scrRes1 to my splitString((item 1 of screensSplit), ",")
			if (count of screensSplit) > 1 then
				set scrRes2 to my splitString(item 2 of screensSplit, ",")
			end if
			
		on error error_string
			set f to (path to preferences from local domain as Unicode text) & "com.apple.windowserver.plist"
			if exists file f of application "Finder" then
				tell application "System Events"
					set v to value of property list item 1 of property list item "DisplaySets" of property list file f
					set {scrRes1, scrRes2} to {{|OriginX|, |OriginY|, |Width|, |Height|} of beginning of v, missing value}
					set screenStr to my joinList(scrRes1, ",")
					if ((count v) > 1) then
						set scrRes2 to {|OriginX|, |OriginY|, |Width|, |Height|} of item 2 of v -- Second screen.
						set screenStr to screenStr & "|" & my joinList(scrRes2, ",")
					else
						set scrRes2 to missing value
					end if
					do shell script "defaults write com.jga23.layouts screens " & quoted form of (screenStr as text)
				end tell
			else
				tell application "Finder"
					set scrRes1 to bounds of window of desktop
					set screenStr to my joinList(scrRes1, ",")
					do shell script "defaults write com.jga23.layouts screens " & quoted form of (screenStr as text)
				end tell
			end if
			
		end try
		if scrRes2 is not false then
			set screens to {scrRes1, scrRes2}
		else
			set screens to {scrRes1}
		end if
	end if
	return screens
end get_screens

on is_inside(pnt, bnds)
	set x to item 1 of pnt
	set y to item 2 of pnt
	if x ≥ item 1 of bnds and x < item 3 of bnds and y ≥ item 2 of bnds and y < item 4 of bnds then
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
	set screens to false
	set perc to 0.8
	set menubar_height to 30

	tell application "System Events" to tell process "Dock"
		set dock_dimensions to size in list 1
		set dock_height to item 2 of dock_dimensions
	end tell

	set front_app to (path to frontmost application as Unicode text)
	tell application front_app
		set app_bounds to bounds of window 1
		set screen to my get_screen_bounds(app_bounds)
		set sx to item 1 of screen
		set sy to item 2 of screen
		set sw to item 3 of screen
		set sh to item 4 of screen
		activate
		if loc is "reset" then
			my reset_screens()
		else
			if loc is "tr" then
				set x to sx + sw / 2
				set y to sy
				set w to sw + sx
				set h to sy + sh / 2
			else if loc is "tl" then
				set x to sx
				set y to sy
				set w to sx + sw / 2
				set h to sy + sh / 2
			else if loc is "bl" then
				set x to sx
				set y to sy + sh / 2
				set w to sx + sw / 2
				set h to sy + sh
			else if loc is "br" then
				set x to sx + sw / 2
				set y to sy + sh / 2
				set w to sx + sw
				set h to sy + sh
			else if loc is "t" then
				set x to sx
				set y to sy
				set w to sx + sw
				set h to sy + sh / 2
			else if loc is "r" then
				set x to sx + sw / 2
				set y to sy
				set w to sx + sw
				set h to sy + sh
			else if loc is "l" then
				set x to sx
				set y to sy
				set w to sx + sw / 2
				set h to sy + sh
			else if loc is "b" then
				set x to sx
				set y to sy + sh / 2
				set w to sx + sw
				set h to sy + sh
			else if loc is "c" then
				set x to sx + sw * (1 - perc)
				set y to sy + sh * (1 - perc) + menubar_height
				set w to sx + sw * perc
				set h to sy + sh * perc - dock_height
			else if loc is "f" then
				set x to sx
				set y to sy
				set w to sx + sw
				set h to sy + sh
			else if loc is "m" then
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

--this can be changed to f,t,b,l,r,tl,tr,bl,br,c,reset
--resize("m")

