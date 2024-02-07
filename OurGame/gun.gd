extends Area2D

@onready var player_health = get_node("/root/Game/Player/ProgressBar")

var xp_level = 1

@onready var in_game_screen = get_node("/root/Game/UI/in_game/GameUI")

var shotgun_level = 0

var mouse_position = Vector2()

var canShoot = true
#var fireRate = 0.125  # 8 clicks per second (1 / 8)

func _physics_process(_delta):
	if player_health.value > 0:
		# Update the mouse position
		mouse_position = get_global_mouse_position()
		
		# Calculate the direction towards the mouse position
		var direction = mouse_position - global_position
		
		# Calculate the angle towards the mouse position
		var angle = direction.angle()
		
		# Set the rotation to the calculated angle
		rotation = angle
	else:
		return

func upgradeshotgun(level):
	shotgun_level = level

func shoot():
	const BULLET = preload("res://bullet.tscn")
	if shotgun_level == 0:
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation 
		%ShootingPoint.add_child(new_bullet)
	elif shotgun_level == 1:
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation 
		%ShootingPoint.add_child(new_bullet)
		
		var new_bullet2 = BULLET.instantiate()
		new_bullet2.global_position = %ShootingPoint.global_position
		new_bullet2.global_rotation = %ShootingPoint.global_rotation -.2
		%ShootingPoint.add_child(new_bullet2)
		
		var new_bullet3 = BULLET.instantiate()
		new_bullet3.global_position = %ShootingPoint.global_position
		new_bullet3.global_rotation = %ShootingPoint.global_rotation +.2
		%ShootingPoint.add_child(new_bullet3)
	else:
		pass


#func _process(delta):
	#if not canShoot:
		#fireRate -= delta
		#if fireRate <= 0:
			#canShoot = true
			#fireRate = 0.125

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and canShoot and player_health.value > 0 and in_game_screen.visible:
		shoot()
		#canShoot = false
