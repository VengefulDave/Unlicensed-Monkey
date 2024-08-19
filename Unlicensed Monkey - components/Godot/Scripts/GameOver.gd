extends Node2D

var save_path = "user://highscore.save"

var mk = monkey.monkeys_killed
var mr = monkey.mag_reloaded
var ss = monkey.shots_shot
var t = game_timer.time

# Called when the node enters the scene tree for the first time.
func _ready():
	var time = game_timer.time
	var mils = fmod(time,1)*1000
	var secs = fmod(time,60)
	var mins = fmod(time,60*60) / 60
	
	var time_passed =  "%02d : %02d : %03d" % [mins,secs,mils]
	$CanvasLayer/Time_Taken.text = "Time taken - " + str(time_passed)
	$CanvasLayer/Bullets_Shot.text = "Bullets shot - " + str(monkey.shots_shot)
	$CanvasLayer/Magazines_Reloaded.text = "Magazines reloaded - " + str(monkey.mag_reloaded)
	$CanvasLayer/Monkeys_Defeated.text = "Monkeys defeated - " + str(monkey.monkeys_killed)
	
	loaddata()
	save()
	

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(mk)
	file.store_var(mr)
	file.store_var(ss)
	file.store_var(t)

func loaddata():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var hmk = file.get_var(mk)
		var hmr = file.get_var(mr)
		var hss = file.get_var(ss)
		var ht = file.get_var(t)
		
		var time = ht
		var mils = fmod(time,1)*1000
		var secs = fmod(time,60)
		var mins = fmod(time,60*60) / 60
		var time_passed =  "%02d : %02d : %03d" % [mins,secs,mils]
		$CanvasLayer/Time_Taken2.text = "Time taken- " + str(time_passed)
		$CanvasLayer/Bullets_Shot2.text = "Bullets shot- " + str(hss)
		$CanvasLayer/Magazines_Reloaded2.text = "Magazines reloaded - " + str(hmr)
		$CanvasLayer/Monkeys_Defeated2.text = "Monkeys defeated - " + str(hmk)
	
