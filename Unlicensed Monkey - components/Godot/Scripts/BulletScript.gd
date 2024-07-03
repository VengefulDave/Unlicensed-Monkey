extends Area2D

@onready var speed = 250


func _process(delta):
	position += transform.x * speed * delta
	


func _ready():
	if !is_in_group("bullet1") and !is_in_group("bullet2") and !is_in_group("bullet3"):
		add_to_group("bullet")
	pass
	


func _on_body_entered(body):
	if !body.name == ("monkey"):
		queue_free()
	else:
		pass
