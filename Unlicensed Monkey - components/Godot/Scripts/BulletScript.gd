extends Area2D

@onready var speed = 300


func _process(delta):
	position += transform.x * speed * delta
	
	


func _on_body_entered(_body):
	queue_free()
