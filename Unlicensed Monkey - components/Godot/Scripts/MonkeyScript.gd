extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -380.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var gun : AnimatedSprite2D = $AnimatedSprite2D2
@onready var bullet = preload("res://Prefab/ak_bullet.tscn")
var shooting = false
var reloading = false
var x_knock_back = 1.5
var y_knock_back = 3
var bullet_count = 30

var shots_shot = 0
var mag_reloaded = 0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if shooting == false and $AnimatedSprite2D2.animation == "Shoot" and reloading == false:
			gun.play("Idle")
	#Walking and direction.
	else:
		if velocity.x > 10:
			anim.play("Run Right")
			if shooting == false and reloading == false:
				gun.play("Walk")
		elif velocity.x < 0:
			anim.play("Run Left")
			if shooting == false and reloading == false:
				gun.play("Walk")
		else:
			anim.play("Idle")
			if shooting == false and reloading == false:
				gun.play("Idle")
			
	# Gun Aiming.
	gun.look_at(get_global_mouse_position())
	if get_global_mouse_position().x < position.x:
		gun.flip_h = true
		gun.scale = Vector2(-1,-1)
	else:
		gun.flip_h = false
		gun.scale = Vector2(1,1)
	
	if Input.is_action_pressed("Left Click"):
		if bullet_count > 0 and reloading == false:
			shooting = true
			gun.play("Shoot")
			if shooting == true and not is_on_floor():
				anim.play("Fly")
			var dis_diff = (position - get_global_mouse_position()).normalized()
			position.x = position.x + (dis_diff.x * x_knock_back)
			if not is_on_floor():
				position.y = position.y + (dis_diff.y * y_knock_back)
			if $Cooldown.is_stopped():
				$Cooldown.start()
				var new_bullet = bullet.instantiate()
				new_bullet.look_at((position - get_global_mouse_position())*-1)
				new_bullet.position = gun.global_position 
				new_bullet.rotation = gun.rotation + randf_range(-0.08,0.08)
				get_parent().add_child(new_bullet)
				shots_shot += 1
				bullet_count = bullet_count - 1  
				
		else:
			if reloading == false:
				reloading_gun()
		
	else:
		shooting = false
	
	if Input.is_action_pressed("R") and shooting == false and reloading == false:
		reloading_gun()
	
	# Handle jump.
	if Input.is_action_pressed("Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
		if reloading == false:
			gun.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	$CanvasLayer/Ammo.value = bullet_count
	
	move_and_slide()
	
	
func reloading_gun():
	reloading = true
	gun.play("Reload")
	await get_tree().create_timer(2).timeout
	bullet_count = 30
	mag_reloaded += 1
	reloading = false	
		
