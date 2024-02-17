extends CharacterBody2D

var health = 3

var xp = 1

var speedbasedonxp = 400

@onready var player = get_node("/root/Game/Player")
@onready var player_xp = get_node("/root/Game/Player/XPBar/XP")

@onready var more_damage_upgrade_level = get_node("/root/Game/UI/in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeMoreDamage/LevelLabel")
@onready var fire_bullets_upgrade_level = get_node("/root/Game/UI/in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeFireBullets/LevelLabel")

const FIRE_BULLETS_PROBABILITY = 0.3

const FIRE_BULLETS_DAMAGE_AMOUNT = 1

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
	
func _process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speedbasedonxp
	move_and_slide()

func take_damage():
	if more_damage_upgrade_level.text == "Current Level: 1":
		health -= 2
	elif more_damage_upgrade_level.text == "Current Level: 2":
		health -= 4
	elif more_damage_upgrade_level.text == "Current Level: 3":
		health -= 6
	else:
		health -= 1
		
	if fire_bullets_upgrade_level.text == "Current Level: 1":
		if randf() < FIRE_BULLETS_PROBABILITY:
			%fire.visible = true
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			%fire.visible = false
		else:
			pass
	elif fire_bullets_upgrade_level.text == "Current Level: 2":
		if randf() < FIRE_BULLETS_PROBABILITY+.2:
			%fire.visible = true
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			%fire.visible = false
		else:
			pass
	elif fire_bullets_upgrade_level.text == "Current Level: 3":
		if randf() < FIRE_BULLETS_PROBABILITY+.2+.5:
			%fire.visible = true
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			await get_tree().create_timer(3).timeout
			health -= FIRE_BULLETS_DAMAGE_AMOUNT
			%Slime.play_hurt()
			%fire.visible = false
		else:
			pass
	else:
		pass
		
	%Slime.play_hurt()
	
	if health <= 0:
		queue_free()
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		mob_died.emit()
