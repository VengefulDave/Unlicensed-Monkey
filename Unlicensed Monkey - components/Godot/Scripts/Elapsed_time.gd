extends Label
@export var time = 0
var timer_on = true
@export var mils = 0
@export var secs = 0
@export var mins = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_on == true:
		time += delta 
		
	mils = fmod(time,1)*1000
	secs = fmod(time,60)
	mins = fmod(time,60*60) / 60
	
	var time_passed =  "%02d : %02d : %03d" % [mins,secs,mils]
	text = time_passed
	
	pass

