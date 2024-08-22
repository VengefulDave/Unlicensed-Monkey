extends Area2D

#Constant speed
@onready var speed = 250

#Makes the bullet travel forward 
func _process(delta):
	position += transform.x * speed * delta
	#Makes the bullet speed randomized for shotgun monkey 
	if is_in_group("bullet2") and speed == 250:
		speed = randi_range(180,230)
	await get_tree().create_timer(6.5).timeout
	queue_free()
	
#Checks if the bullet belongs to enemies, if not, belongs to player
func _ready():
	if !is_in_group("bullet1") and !is_in_group("bullet2") and !is_in_group("bullet3"):
		add_to_group("bullet")
	pass
	
#Checks collision with object
func _on_body_entered(body):
	#Gives enough time for bullet to touch monke to calculate damage properly
	if body.name == "Monkey":
		await get_tree().create_timer(0.05).timeout
		queue_free()
	#Allows the gorrilas bullets to pass though his hitbox
	if body is badmonkey3 and is_in_group("bullet3"):
		pass
	else:
		#Deletes itself if hits an object
		queue_free()
		
