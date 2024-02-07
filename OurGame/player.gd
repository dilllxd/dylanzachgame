extends CharacterBody2D

@onready var ui = $"../../Game/UI"

@onready var in_game_screen = get_node("/root/Game/UI/in_game/GameUI")

signal health_depleted

var speed_boost_level = 0

var health_upgrade_level = 0

var health = 100.0
var healthmax = 100.0

var isHealthDepleted = false
var started = false

var xp_level = 1

var xp_level_scaling = null

func _ready():
	ui.game_started.connect(_started)

func _started():
	started = true
	checkhealth()
	
func upgradespeed(level):
	speed_boost_level = level

func upgradehealth(level):
	health_upgrade_level = level
	checkhealth()

func currentxplevel(level):
	xp_level = level

func checkhealth():
	if health_upgrade_level == 0:
		health = 100.0
		healthmax = 100.0
	elif health_upgrade_level == 1:
		health = 200.0
		healthmax = 200.0
	elif health_upgrade_level == 2:
		health = 300.0
		healthmax = 300.0
	else:
		pass

func _physics_process(delta):
	if not started and in_game_screen.visible == false:
		return
	elif started == true and in_game_screen.visible == true:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if speed_boost_level == 0:
			velocity = direction * 600
		elif speed_boost_level == 1:
			velocity = direction * 800
		elif speed_boost_level == 2:
			velocity = direction * 900
		elif speed_boost_level == 3:
			velocity = direction * 1000
		else:
			velocity = direction * 600
		move_and_slide()
		if velocity.length() > 0.0:
			%HappyBoo.play_walk_animation()
		else:
			%HappyBoo.play_idle_animation()
			
		const DAMAGE_RATE = 5.0
		var overlapping_mobs = %HurtBox.get_overlapping_bodies()
		if overlapping_mobs.size() > 0:
			xp_level_scaling = xp_level * 0.75
			health -= DAMAGE_RATE * overlapping_mobs.size() * delta * xp_level_scaling
			%ProgressBar.max_value = healthmax
			%ProgressBar.value = health
			if health <= 0.0 and not isHealthDepleted:
				isHealthDepleted = true
				health_depleted.emit()
				%HappyBoo/Colorizer/SquareBody/SquareFaceAlive.visible = false
				%HappyBoo/Colorizer/SquareBody/SquareFaceDead.visible = true
				
