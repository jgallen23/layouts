# Layouts

Layouts is an applescript and an [alfred](http://www.alfredapp.com/) extension to easily move and resize application windows. 

![Example Layout](ui/layouts.jpg)

##Alfred

You can download the alfred extension [here](https://github.com/jgallen23/layouts/raw/master/dist/Layouts.alfredextension).

###Command
- resize [f, t, b, l, r, tl, tr, bl, br, c, m]

###Layouts
- f: full screen
- c: center window 
- t: top half of screen
- b: bottom half of screen
- l: left half of screen
- r: right half of screen
- tl: top left quarter of screen 
- tr: top right quarter of screen 
- bl: bottom left quarter of screen 
- br: bottom right quarter of screen 
- m: move to next monitor

###Hotkey support
Thanks to Alfred's new hotkey feature, you don't even have to trigger alfred to move your windows around.

![Hotkeys](ui/layouts-hotkeys.jpg)

##Applescript
Here's the applescript that is powering the extension, which you can use by itself:

	-- v0.0.3

	on get_screens()
		set f to (path to preferences from local domain as Unicode text) & "com.apple.windowserver.plist"
		
		tell application "System Events"
			set v to value of property list item 1 of property list item "DisplaySets" of property list file f
			set {scrRes1, scrRes2} to {{|OriginX|, |OriginY|, |Width|, |Height|} of beginning of v, missing value}
			if ((count v) > 1) then set scrRes2 to {|OriginX|, |OriginY|, |Width|, |Height|} of item 2 of v -- Second screen.
		end tell
		return {scrRes1, scrRes2}
	end get_screens

	on get_screen_bounds(app_bounds)
		set screens to my get_screens()
		set app_x to item 1 of app_bounds
		set app_y to item 2 of app_bounds
		set screen1 to item 1 of screens
		if app_x ≥ item 1 of screen1 and app_y ≥ item 2 of screen1 then
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


###Command Line
The script will work via the command line too! *Make sure to uncomment the on run argv lines if you want to use it this way*

	osascript layouts.applescript f

Go [here](https://raw.github.com/jgallen23/layouts/master/layouts.applescript) to download the script

##History
####0.0.3 (03/18/2012)
- multi monitor support

####0.0.2
- bug fixes

####0.0.1
- initial release

##Future
- automatic update support
- custom sizes

##Contributors
- Greg Allen ([@jgaui](http://twitter.com/jgaui)) [jga.me](http://jga.me)
