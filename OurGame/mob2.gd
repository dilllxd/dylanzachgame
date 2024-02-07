extends CharacterBody2D

var health = 6

@onready var player = get_node("/root/Game/Player")

signal mob_died2

func _ready():
	%Slime2.play_walk()

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 400
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
