extends Label

var time = 0
var timer_on = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_on == true:
		time += delta
		
	var mils = snapped(fmod(time,1)*1000, 0)
	var secs = round(fmod(time,60))
	var mins = round(fmod(time,60*60) / 60)
	
	var time_passed =  "%s : %s : %s" % [mins,secs,mils]
	text = time_passed

