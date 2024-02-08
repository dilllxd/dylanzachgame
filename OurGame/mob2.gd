extends CharacterBody2D

var health = 6

var xp = 1

var speedbasedonxp = 450

@onready var player = get_node("/root/Game/Player")
@onready var player_xp = get_node("/root/Game/Player/XPBar/XP")

signal mob_died2

func _ready():
	%Slime2.play_walk()
	xp = int(player_xp.text)
	if xp >= 2:
		health = 8
		speedbasedonxp = 475
	elif xp >= 4:
		health = 10
		speedbasedonxp = 500
	elif xp >= 7:
		health = 12
		speedbasedonxp = 550
	elif xp >= 10:
		health = 14
		speedbasedonxp = 600
	elif xp >= 12:
		health = 16
		speedbasedonxp = 700
	elif xp >= 15:
		health = 18
		speedbasedonxp = 725
	else:
		health = 6
		speedbasedonxp = 450

func _process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speedbasedonxp
	move_and_slide()

func take_damage():
	health -= 1
	%Slime2.play_hurt()
	
	if health == 0:
		queue_free()
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		mob_died2.emit()
