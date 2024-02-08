extends CharacterBody2D

var health = 3

var xp = 1

var speedbasedonxp = 400

@onready var player = get_node("/root/Game/Player")
@onready var player_xp = get_node("/root/Game/Player/XPBar/XP")

signal mob_died

func _ready():
	%Slime.play_walk()
	xp = int(player_xp.text)
	if xp >= 2:
		health = 4
		speedbasedonxp = 400
	elif xp >= 4:
		health = 6
		speedbasedonxp = 450
	elif xp >= 7:
		health = 8
		speedbasedonxp = 500
	elif xp >= 10:
		health = 10
		speedbasedonxp = 600
	elif xp >= 12:
		health = 13
		speedbasedonxp = 650
	elif xp >= 15:
		health = 15
		speedbasedonxp = 700
	else:
		health = 3
		speedbasedonxp = 400
	
func _process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speedbasedonxp
	move_and_slide()

func take_damage():
	health -= 1
	%Slime.play_hurt()
	
	if health == 0:
		queue_free()
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		mob_died.emit()
