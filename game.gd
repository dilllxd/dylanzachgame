extends Node2D

var number_of_mobs = 0

var points = 0

@onready var ui = $UI
@onready var timer = $Timer
@onready var ttimer = $TreeTimer

signal game_has_started

func _ready():
	ui.game_started.connect(_start)

func _start():
	game_has_started.emit()
	ui.update_ui()
	timer.start()
	ttimer.start()

func spawn_mob():
	const MOB_INSTANCE = preload("res://mob.tscn")
	var new_mob = MOB_INSTANCE.instantiate()
	
	new_mob.mob_died.connect(_on_mob_died)
	
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	number_of_mobs += 1
	#print("A mob has spawned. Remaining mobs:", number_of_mobs) # Only uncomment for debugging

func spawn_tree():
	const TREE_INSTANCE = preload("res://pine_tree.tscn")
	var new_tree = TREE_INSTANCE.instantiate()
	
	%PathFollow2D.progress_ratio = randf()
	new_tree.global_position = %PathFollow2D.global_position
	add_child(new_tree)

func _on_tree_timer_timeout():
	spawn_tree()

func _on_timer_timeout():
	if number_of_mobs < 25:
		spawn_mob()
	else:
		pass

func _on_mob_died():
	number_of_mobs -= 1
	points += 1
	ui.update_points(points)
	ui.update_ui()
	#print("A mob has died. Remaining mobs:", number_of_mobs) # Only uncomment for debugging
	if number_of_mobs < 25:
		spawn_mob()

func _on_player_health_depleted():
	ui.on_game_over()
