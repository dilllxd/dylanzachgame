extends CharacterBody2D

@onready var ui = $"../../Game/UI"

@onready var in_game_screen = get_node("/root/Game/UI/in_game/GameUI")

signal health_depleted

var health = 100.0
var isHealthDepleted = false
var started = false

func _ready():
	ui.game_started.connect(_started)

func _started():
	started = true

func _physics_process(delta):
	if not started and in_game_screen.visible == false:
		return
	elif started == true and in_game_screen.visible == true:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = direction * 600
		move_and_slide()

		if velocity.length() > 0.0:
			%HappyBoo.play_walk_animation()
		else:
			%HappyBoo.play_idle_animation()

		const DAMAGE_RATE = 5.0
		var overlapping_mobs = %HurtBox.get_overlapping_bodies()
		if overlapping_mobs.size() > 0:
			health -= DAMAGE_RATE * overlapping_mobs.size() * delta
			%ProgressBar.value = health
			if health <= 0.0 and not isHealthDepleted:
				isHealthDepleted = true
				health_depleted.emit()
				%HappyBoo/Colorizer/SquareBody/SquareFaceAlive.visible = false
				%HappyBoo/Colorizer/SquareBody/SquareFaceDead.visible = true
