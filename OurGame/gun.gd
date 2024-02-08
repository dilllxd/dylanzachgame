extends Area2D

@onready var player_health = get_node("/root/Game/Player/ProgressBar")

var xp_level = 1

@onready var in_game_screen = get_node("/root/Game/UI/in_game/GameUI")
@onready var main_menu = get_node("/root/Game/UI/main_menu/MenuUI")
@onready var settings = get_node("/root/Game/UI/settings/SettingsUI")

var shotgun_level = 3

var mouse_position = Vector2()

func _physics_process(_delta):
	if player_health.value > 0:
		# Calculate rotation based on mouse input
		var mouse_direction = get_global_mouse_position() - global_position
		var mouse_angle = mouse_direction.angle()

		# Calculate rotation based on controller input
		var controller_direction = Vector2(
			Input.get_action_strength("rotate_right") - Input.get_action_strength("rotate_left"),
			Input.get_action_strength("rotate_down") - Input.get_action_strength("rotate_up")
		)
		if controller_direction.length_squared() > 0.01: # Avoid division by zero
			var controller_angle = controller_direction.angle()
			rotation = controller_angle
		else:
			rotation = mouse_angle
	else:
		return

func upgradeshotgun(level):
	shotgun_level = level

#func shoot():
	#const BULLET = preload("res://bullet.tscn")
	#var new_bullet = BULLET.instantiate()
	#var new_bullet2 = BULLET.instantiate()
	#var new_bullet3 = BULLET.instantiate()
	#var new_bullet4 = BULLET.instantiate()
	#var new_bullet5 = BULLET.instantiate()
	#new_bullet.global_position = %ShootingPoint.global_position
	#new_bullet.global_rotation = %ShootingPoint.global_rotation 
	#new_bullet2.global_position = %ShootingPoint.global_position
	#new_bullet2.global_rotation = %ShootingPoint.global_rotation -.2
	#new_bullet3.global_position = %ShootingPoint.global_position
	#new_bullet3.global_rotation = %ShootingPoint.global_rotation +.2
	#new_bullet4.global_position = %ShootingPoint.global_position
	#new_bullet4.global_rotation = %ShootingPoint.global_rotation -.4
	#new_bullet5.global_position = %ShootingPoint.global_position
	#new_bullet5.global_rotation = %ShootingPoint.global_rotation +.4
	#
	#if shotgun_level == 0:
		#%ShootingPoint.add_child(new_bullet)
	#elif shotgun_level == 1:
		#%ShootingPoint.add_child(new_bullet)
		#%ShootingPoint.add_child(new_bullet2)
		#%ShootingPoint.add_child(new_bullet3)
	#elif shotgun_level == 2:
		#%ShootingPoint.add_child(new_bullet)
		#%ShootingPoint.add_child(new_bullet2)
		#%ShootingPoint.add_child(new_bullet3)
		#%ShootingPoint.add_child(new_bullet4)
		#%ShootingPoint.add_child(new_bullet5)
	#else:
		#%ShootingPoint.add_child(new_bullet)
		
func shoot():
	const BULLET = preload("res://bullet.tscn")
	var bullet_count = 1
	var bullet_angle_increment = 0

	if shotgun_level > 0:
		bullet_count = 2 + shotgun_level
		bullet_angle_increment = 0.2

	var bullets = []

	for i in range(bullet_count):
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation + i * bullet_angle_increment - (bullet_angle_increment * (bullet_count - 1)) / 2
		bullets.append(new_bullet)
		%ShootingPoint.add_child(new_bullet)

var mouse_left_down: bool = false
var time_held_down: float = 0
var auto_shoot_delay: float = 0.7 # Delay before auto-shooting starts (in seconds)
var time_since_last_shot: float = 0
var shoot_interval: float = 1000.0 / 7 # Interval for shooting approximately 7 times per second, using a float operand
var canShoot: bool = false

func _input(event):
	if event.is_action_pressed("fire_shot") and player_health.value > 0 and main_menu.visible == false and settings.visible == false:
		mouse_left_down = true
		time_held_down = 0
		shoot() # Perform an immediate shot when clicked

	elif event.is_action_released("fire_shot"):
		mouse_left_down = false
		canShoot = false # Reset auto-shooting flag when mouse button is released

func _process(delta):
	if mouse_left_down:
		time_held_down += delta

		# Enable auto-shooting after the delay
		if time_held_down >= auto_shoot_delay:
			canShoot = true

		if canShoot and player_health.value > 0 and main_menu.visible == false and settings.visible == false:
			time_since_last_shot += delta * 1000 # Convert delta to milliseconds
			if time_since_last_shot >= shoot_interval:
				shoot()
				time_since_last_shot = 0
