extends Area2D

@onready var speed = 250


func _process(delta):
	position += transform.x * speed * delta
	if is_in_group("bullet2") and speed == 250:
		speed = randi_range(180,230)
	await get_tree().create_timer(6.5).timeout
	queue_free()
	


func _ready():
	if !is_in_group("bullet1") and !is_in_group("bullet2") and !is_in_group("bullet3"):
		add_to_group("bullet")
	pass
	


func _on_body_entered(body):
	if body.name == "Monkey":
		await get_tree().create_timer(0.05).timeout
		queue_free()
	queue_free()
	
