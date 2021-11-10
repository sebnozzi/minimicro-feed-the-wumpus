clear

print "Loading sounds ..."

hit = file.loadSound("/sys/sounds/hit.wav")
pickup = file.loadSound("/sys/sounds/pickup.wav")

clear

// Draw background
gfx.clear color.white
gfx.fillRect 0,0,960,50,color.brown
bgImg = file.loadImage("kitchen Background Lite.png")
gfx.drawImage bgImg,0,0

// Set a good text color for background
// Set a good text color suitable to the background
text.color = "#5f5f5f"

sprtDisp = display(4)

m = new Sprite
m.image = file.loadImage("/sys/pics/food/Muffin.png")
m.x = 400 // from 50 to 910
m.y = 590 // to 40
m.localBounds = new Bounds
m.localBounds.width = m.image.width
m.localBounds.height = m.image.height
m.moveToTop = function()
	m.x = 50 + rnd * (910-50)
	m.y = 590
end function

sprtDisp.sprites.push m

w = new Sprite
w.image = file.loadImage("/sys/pics/Wumpus.png")
w.y = 80 // fixed
w.x = 80 // to 880
w.localBounds = new Bounds
w.localBounds.width = w.image.width
w.localBounds.height = w.image.height

sprtDisp.sprites.push w

caught = 0
missed = 0
countdown = time + 30

// This is for showing the statistics on the screen
showStatistics = function()
	// Backup the current text display settings
	textColor = text.color
	textRow = text.row
	textCol = text.column
	textDelim = text.delimiter
	
	// Don't go to a newline after printing
	text.delimiter = ""
	
	// Clean up statistics area
	for col in range(23,25)
		for row in range(53,67)
			text.setCell col,row,""
		end for		
	end for
	
	// Print statistics - placing text on the screen
	text.row = 25
	text.column = 53
	print "Countdown: " + remainingTime
	text.row = 24
	text.column = 53
	print "Caught: " + caught
	text.row = 23
	text.column = 53
	print "Missed: " + missed
	
	// Restore previous settings
	text.delimiter = textDelim
	text.column = textCol
	text.row = textRow
	text.color = textColor
end function

scrollTextUp = function(startRow)
	// Scroll one line up
	for row in range(25,startRow+1,-1)
		for col in range(0,20)
			c = text.cell(col,row-1)
			text.setCell(col,row,c)
		end for
	end for
	text.row = text.row + 1
end function

// Print a message, scrolling the message section if necessary
showMessage = function(msg)
	if text.row == 25-10 then
		// Scroll one line up
		scrollTextUp(25-10)
	end if
	print msg
end function

lastTime = time
while true
	remainingTime = floor(countdown - time)
	
	// Calculate delta-time for animations
	dt = time - lastTime
	lastTime = time
	
	// Let the muffin fall
	m.y = m.y - 430*dt
	
	if key.pressed("right") then
		w.x = w.x + 375*dt
		w.rotation = 360-7
	else if key.pressed("left") then
		w.x = w.x - 375*dt
		w.rotation = 7
	else
		w.rotation = 0
	end if
	
	// Muffin touching Wumpus!
	if m.overlaps(w) then
		pickup.play
		showMessage "AHHMMM!!"
		caught = caught + 1
		m.moveToTop
	else if m.y < 40 then
		hit.play
		showMessage "Too slow!"
		missed = missed + 1
		m.moveToTop
	end if
	
	showStatistics
	
	if remainingTime <= 0 then
		print
		print " " * 30 + "GAME OVER"
		print
		exit
	end if
	
	if key.available then
		k = key.get
		if k == "q" or key.pressed("escape") then
			exit
		end if
	end if
	
	yield
end while