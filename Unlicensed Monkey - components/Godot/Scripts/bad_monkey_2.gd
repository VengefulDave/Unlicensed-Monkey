extends CharacterBody2D

const SPEED = 6500


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D
@onready var gun = $AnimatedSprite2D2
@onready var gmonkey = get_parent().get_node("Monkey")
@onready var bullet = preload("res://Prefab/ak_bullet.tscn")
var direction = 1
var looking = false
var shooting = false
var HEALTH = 10
var hit = false

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
	velocity.y += gravity * delta
	
	if !$RayCastLeft.is_colliding() and is_on_floor() or $RayCastFLeft.is_colliding():
		direction = 1
	elif !$RayCastRight.is_colliding() and is_on_floor() or $RayCastFRight.is_colliding():
		direction = -1
	
	if $WalkTime.is_stopped():
		monkey_walk()
	
	velocity.x = direction * SPEED * delta

	if velocity.x > 0:
		anim.play("Run Right")
		if looking == false and shooting == false:
			gun.flip_h = false
			gun.rotation = 0
			gun.play("Run")
	elif velocity.x < 0:
		anim.play("Run Left")
		if looking == false and shooting == false:
			gun.flip_h = true
			gun.rotation = 0
			gun.play("Run")
	else: 
		if shooting == false:
			if !$AnimatedSprite2D.animation == "Hit":
				anim.play("Idle")
			gun.pause()
	
	if HEALTH <= 0:
		monkey.b_monkey_2_dead = true
		queue_free()
		
	
	if gmonkey in $vision.get_overlapping_bodies():
		looking = true
		$AnimatedSprite2D2.look_at(gmonkey.position)
		if gun.global_position.x > gmonkey.global_position.x:
			gun.flip_h = true
			gun.scale = Vector2(-1,-1)
		elif gun.global_position.x < gmonkey.global_position.x:
			gun.flip_h = false
			gun.scale = Vector2(1,1)
		shoot()
	else:
		looking = false
		gun.scale = Vector2(1,1)
		
	move_and_slide()

func monkey_walk():
	direction = 0
	$WalkTime.wait_time = randi_range(1,3)
	#Amount of time the monkey stands still \/
	await get_tree().create_timer(randi_range(1,4)).timeout
	if !abs(direction) > 0: 
		direction = randi_range(-1,1)
		$WalkTime.start()

func shoot():
	$ShootCool.wait_time = randf_range(2,3)
	if $ShootCool.is_stopped():
		shooting = true
		for i in (9):
			var new_bullet = bullet.instantiate()
			new_bullet.add_to_group("bullet2")
			new_bullet.look_at((position - get_global_mouse_position())*-1)
			new_bullet.position = gun.global_position 
			new_bullet.rotation = gun.rotation + randf_range(-0.1,0.1)
			get_parent().add_child(new_bullet)
		gun.play("Shoot")
		$ShootCool.start()
	else:
		shooting = false
		
		

func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		HEALTH -= 1
		anim.play("Hit")
		
	pass
	


