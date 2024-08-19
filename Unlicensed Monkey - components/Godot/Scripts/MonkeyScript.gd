extends CharacterBody2D
class_name monkey

static var b_monkey_dead = false
static var b_monkey_2_dead = false
static var b_monkey_3_dead = false

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
var y_knock_back = 9
var bullet_count = 30
var HEALTH = 100
var healing = false
var music_play = false
var checkpoint = Vector2(450,120) 

static var monkeys_killed = 0
static var shots_shot = 0
static var mag_reloaded = 0


func _physics_process(delta):
	if music_play == false:
		var chance = randi_range(0,1)
		if chance == 1:
			$Background1.play()
		if chance == 0:
			$Background2.play()
		music_play = true
	
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
			if shooting == true and not is_on_floor():
				anim.play("Fly")
			var dis_diff = (position - get_global_mouse_position()).normalized()
			position.x = position.x + (dis_diff.x * x_knock_back)
			if not is_on_floor():
				velocity.y =+ velocity.y + (dis_diff.y * y_knock_back)
			if $Cooldown.is_stopped():
				$Cooldown.start()
				$GunShoot.pitch_scale = randf_range(0.9,1.1)
				$GunShoot.play()
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
	
	if HEALTH <= 0 or position.y > 1500:
		position = checkpoint
		HEALTH = 100
		$CanvasLayer/Elapsed_time.time += 10
		$CanvasLayer/timeminusplus.add_theme_color_override("font_color", Color(1,0,0))
		$CanvasLayer/timeminusplus.add_theme_font_size_override("font_size",25)
		$CanvasLayer/timeminusplus.text = "+10"
		await get_tree().create_timer(3).timeout
		$CanvasLayer/timeminusplus.text = ""
	
	if b_monkey_dead == true:
		monkeys_killed += 1
		$CanvasLayer/Elapsed_time.time -= 3
		$CanvasLayer/timeminusplus.add_theme_color_override("font_color", Color(0,1,0))
		$CanvasLayer/timeminusplus.add_theme_font_size_override("font_size",25)
		$CanvasLayer/timeminusplus.text = "-3"
		if HEALTH < 100:
			HEALTH += 1
		b_monkey_dead = false
		await get_tree().create_timer(1).timeout
		$CanvasLayer/timeminusplus.text = ""
	
	if b_monkey_2_dead == true:
		monkeys_killed += 1
		$CanvasLayer/Elapsed_time.time -= 4
		$CanvasLayer/timeminusplus.add_theme_color_override("font_color", Color(0,1,0))
		$CanvasLayer/timeminusplus.add_theme_font_size_override("font_size",25)
		$CanvasLayer/timeminusplus.text = "-4"
		if HEALTH < 100:
			HEALTH += 2
		b_monkey_2_dead = false
		await get_tree().create_timer(1).timeout
		$CanvasLayer/timeminusplus.text = ""
	
	if b_monkey_3_dead == true:
		monkeys_killed += 1
		$CanvasLayer/Elapsed_time.time -= 8
		$CanvasLayer/timeminusplus.add_theme_color_override("font_color", Color(0,1,0))
		$CanvasLayer/timeminusplus.add_theme_font_size_override("font_size",25)
		$CanvasLayer/timeminusplus.text = "-8"
		if HEALTH < 100:
			HEALTH += 8
		b_monkey_3_dead = false
		await get_tree().create_timer(1).timeout
		$CanvasLayer/timeminusplus.text = ""
	
	
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
	
	if $HealthTick.is_stopped() and healing == false and HEALTH > 0 and HEALTH < 100:
		healing = true
		HEALTH += 3
		$HealthTick.start()
		healing = false
	
	$CanvasLayer/Ammo.value = bullet_count
	$CanvasLayer/Health.value = HEALTH
	$CanvasLayer/Health_counter.text = str(HEALTH)
	
	if HEALTH > 100:
		HEALTH = 100
	
	move_and_slide()
	
	
func reloading_gun():
	reloading = true
	$ReloadS.play()
	gun.play("Reload")
	await get_tree().create_timer(2).timeout
	bullet_count = 30
	mag_reloaded += 1
	reloading = false	
		

func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet1"):
		HEALTH -= 7
		anim.play("Hit")
	elif area.is_in_group("bullet2"):
		HEALTH -= 2
		anim.play("Hit")
	elif area.is_in_group("bullet3"):
		HEALTH -= 1
		anim.play("Hit")
	else:
		pass
	

func _on_area_2d_body_entered(body):
	if body.name == "Monkey":
		checkpoint = Vector2(11300,-2200)
		position = checkpoint

func _on_area_2d_2_body_entered(body):
	if body.name == "Monkey":
		checkpoint = Vector2(22000, -1500)
		position = checkpoint
	

func _on_area_2d_3_body_entered(body):
	if body.name == "Monkey":
		game_timer.timer_on = false
		await get_tree().create_timer(0.5).timeout
		end_game()
		
func end_game():
	get_tree().change_scene_to_file("res://GameOver.tscn")


func _on_background_2_finished():
	music_play = false


func _on_background_1_finished():
	music_play = false
