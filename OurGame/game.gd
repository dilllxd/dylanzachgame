extends Node2D

var number_of_mobs = 0

var points = 0
var xp = 0
var xp_level = 1
var mobs_to_next_level = 30
var mobs_per_level_increase = 10
var number_of_mobs2 = 0


@onready var ui = $UI
@onready var timer = $Timer
@onready var ttimer = $TreeTimer

signal game_has_started

func _ready():
	ui.game_started.connect(_start)

func _start():
	game_has_started.emit()
	ui.update_points(points)
	ui.update_xp(xp_level)
	ui.update_ui()
	update_xp()
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
	
func spawn_mob2():
	const MOB_INSTANCE2 = preload("res://mob2.tscn")
	var new_mob2 = MOB_INSTANCE2.instantiate()
	
	new_mob2.mob_died2.connect(_on_mob_died2)
	
	%PathFollow2D.progress_ratio = randf()
	new_mob2.global_position = %PathFollow2D.global_position
	add_child(new_mob2)
	number_of_mobs2 += 1

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
	elif number_of_mobs2 < 5:
		spawn_mob2()
	else:
		pass

func _on_mob_died():
	number_of_mobs -= 1
	points = 1
	ui.update_points(points)
	ui.update_xp(xp_level)
	ui.update_ui()
	update_xp()
	if number_of_mobs < 25:
		spawn_mob()

func _on_mob_died2():
	number_of_mobs2 -= 1
	points = 3
	ui.update_points(points)
	ui.update_xp(xp_level)
	ui.update_ui()
	update_xp()
	if number_of_mobs2 < 5:
		spawn_mob2()
	
func update_xp():
	xp += 1
	if xp >= mobs_to_next_level:
		xp -= mobs_to_next_level
		xp_level += 1
		mobs_to_next_level += mobs_per_level_increase
		ui.update_xp(xp_level)
		ui.update_ui()

func _on_player_health_depleted():
	ui.on_game_over()
