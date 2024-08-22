extends CharacterBody2D
class_name badmonkey3

const SPEED = 6000


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D
@onready var gun = $AnimatedSprite2D2
@onready var gmonkey = get_parent().get_node("Monkey")
@onready var bullet = preload("res://Prefab/ak_bullet.tscn")
var direction = 1
var looking = false
var shooting = false
var HEALTH = 24
var hit = false

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
	velocity.y += gravity * delta
	
	#Checks if is about to walk of the edge of map
	if !$RayCastLeft.is_colliding() and is_on_floor() or $RayCastFLeft.is_colliding():
		direction = 1
	elif !$RayCastRight.is_colliding() and is_on_floor() or $RayCastFRight.is_colliding():
		direction = -1
	
	#Cooldown before moving around
	if $WalkTime.is_stopped():
		monkey_walk()
	
	velocity.x = direction * SPEED * delta
	
	#Decides direction of animation on where its traveling
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
		anim.play("Run Left")
		if looking == false and shooting == false:
			gun.flip_h = true
			gun.rotation = 0
			gun.play("Run")
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
		anim.play("Run Left")
		if looking == false and shooting == false:
			gun.flip_h = false
			gun.rotation = 0
			gun.play("Run")
	else: 
		if shooting == false:
			if !$AnimatedSprite2D.animation == "Hit":
				anim.play("Idle")
			gun.pause()
	
	#Checks if it has no health- sends signal to player script that they killed an enemy
	if HEALTH <= 0:
		monkey.b_monkey_3_dead = true
		queue_free()
		
	#Checks if the player is in its vision area
	if gmonkey in $vision.get_overlapping_bodies():
		looking = true
		$AnimatedSprite2D2.look_at(gmonkey.position)
		if gun.global_position.x > gmonkey.global_position.x:
			gun.flip_h = false
			gun.scale = Vector2(-1,-1)
		elif gun.global_position.x < gmonkey.global_position.x:
			gun.flip_h = true
			gun.scale = Vector2(1,1)
		shoot()
	else:
		looking = false
		gun.scale = Vector2(1,1)
		
	#Resets the enemy if the player isnt in its vision but its still shooting
	if gmonkey not in $vision.get_overlapping_bodies() and $AnimatedSprite2D2.animation == "Shoot":
		gun.scale = Vector2(1,1)
		looking = false
		gun.stop()
		shooting = false
		
	move_and_slide()

#Randomizes walk time and direction
func monkey_walk():
	direction = 0
	$WalkTime.wait_time = randi_range(1,3)
	#Amount of time the monkey stands still \/
	await get_tree().create_timer(randi_range(1,4)).timeout
	if !abs(direction) > 0: 
		direction = randi_range(-1,1)
		$WalkTime.start()

#Controls shooting
func shoot():
	if $ShootCool.is_stopped():
		shooting = true
		$GunShoot.pitch_scale = randf_range(0.9,1)
		$GunShoot.play()
		#Adds a copy of bullet to scene as child
		var new_bullet = bullet.instantiate()
		new_bullet.add_to_group("bullet3")
		new_bullet.look_at((position - get_global_mouse_position())*-1)
		new_bullet.position = gun.global_position 
		new_bullet.rotation = gun.rotation + randf_range(-0.1,0.1)
		get_parent().add_child(new_bullet)
		gun.play("Shoot")
		$ShootCool.start()
	else:
		shooting = false
		
#Checks whether the player shot the enemy
func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		HEALTH -= 1
		anim.play("Hit")
		
	pass
	
