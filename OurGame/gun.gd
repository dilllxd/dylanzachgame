extends Area2D

@onready var player_health = get_node("/root/Game/Player/ProgressBar")

@onready var game_points = get_node("/root/Game/UI/in_game/GameUI/in_game_score/points")

@onready var in_game_screen = get_node("/root/Game/UI/in_game/GameUI")

var shotgun = false

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

func shoot():
	const BULLET = preload("res://bullet.tscn")
	var shotgun = false
	if shotgun == true:
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation 
		%ShootingPoint.add_child(new_bullet)
		
		var new_bullet2 = BULLET.instantiate()
		new_bullet2.global_position = %ShootingPoint.global_position
		new_bullet2.global_rotation = %ShootingPoint.global_rotation -1
		%ShootingPoint.add_child(new_bullet2)
		
		var new_bullet3 = BULLET.instantiate()
		new_bullet3.global_position = %ShootingPoint.global_position
		new_bullet3.global_rotation = %ShootingPoint.global_rotation +1
		%ShootingPoint.add_child(new_bullet3)
	else:
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation 
		%ShootingPoint.add_child(new_bullet)

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
