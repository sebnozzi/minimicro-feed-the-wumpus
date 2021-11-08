clear

print "Loading sounds ..."

hit = file.loadSound("/sys/sounds/hit.wav")
pickup = file.loadSound("/sys/sounds/pickup.wav")

clear

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

text.color = "#C0C0C0CC"

while true
	remainingTime = floor(countdown - time)
	
	// Let the muffin fall
	m.y = m.y - 7
	
	if key.pressed("right") then
		w.x = w.x + 6
		w.rotation = 360-7
	else if key.pressed("left") then
		w.x = w.x - 6
		w.rotation = 7
	else
		w.rotation = 0
	end if
	
	// Muffin touching Wumpus!
	if m.overlaps(w) then
		pickup.play
		print "AHHMMM!!"
		caught = caught + 1
		m.moveToTop
	else if m.y < 40 then
		hit.play
		print "Too slow!"
		missed = missed + 1
		m.moveToTop
	end if
	
	gfx.clear
	gfx.print "Countdown: " + remainingTime,770,600,color.silver
	gfx.print "Caught: "+caught,770,570,color.silver
	gfx.print "Missed: "+missed,770,540,color.silver
	
	if remainingTime <= 0 then
		print "GAME OVER"
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