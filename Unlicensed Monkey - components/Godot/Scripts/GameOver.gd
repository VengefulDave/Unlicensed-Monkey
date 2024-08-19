extends Node2D

var save_path = "user://highscore.save"

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
	
func save():
	var file = FileAccess.open(save_path)
	
	
	
	
	
	
