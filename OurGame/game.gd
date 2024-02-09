extends Node2D

var number_of_mobs = 0
var number_of_mobs2 = 0
var maxnumber_of_mobs = 25
var maxnumber_of_mobs2 = 5

var points = 0
var xp = 0
var xp_level = 1
var mobs_to_next_level = 30
var mobs_per_level_increase = 10

const SPAWN_UPDATE_INTERVAL = 0
var spawn_update_timer = 0.0
var occupied_areas = {}
var spawn_points = []


@onready var ui = $UI
@onready var timer = $Timer
@onready var ttimer = $TreeTimer
@onready var player = $Player

signal game_has_started

func _process(delta):
	spawn_update_timer += delta
	if spawn_update_timer >= SPAWN_UPDATE_INTERVAL:
		update_spawn_points()
		spawn_update_timer = 0.0
		spawn_tree()
		
func _ready():
	ui.game_started.connect(_start)
	update_spawn_points()

func update_spawn_points():
	# Clear existing spawn points
	spawn_points.clear()
	
	# Populate spawn_points array with the positions along the path
	%PathFollow2D2.progress_ratio = randf()
	var point = %PathFollow2D2.global_position
	spawn_points.append(point)

func is_position_occupied(pos):
	for tree_area in occupied_areas:
		if occupied_areas[tree_area].has_point(pos):
			return true
	return false

func spawn_tree():
	# Check if there are available spawn points
	if spawn_points.size() == 0:
		return
	
	# Randomly select a spawn point index
	var spawn_index = randi() % spawn_points.size()
	var spawn_point = spawn_points[spawn_index]
	
	# Check if the spawn point is already occupied
	if is_position_occupied(spawn_point):
		return
	
	# Instantiate the tree
	var new_tree = preload("res://pine_tree.tscn").instantiate()
	new_tree.global_position = spawn_point
	add_child(new_tree)
	
	var tree_sprite_size = Vector2(200, 200)

	# Desired buffer space around the sprite size
	var buffer_space = Vector2(20, 20)
	
	# Calculate the occupied area size
	var occupied_area_size = (tree_sprite_size + buffer_space) * 2
	
	# Adjust the spawn area based on the occupied area size
	var tree_area = Rect2(spawn_point - occupied_area_size / 2, occupied_area_size)
	occupied_areas[new_tree] = tree_area
	
	# Remove the chosen spawn point from the array
	spawn_points.pop_back()
	
func _start():
	game_has_started.emit()
	ui.update_points(points)
	ui.update_xp(xp_level)
	ui.update_ui()
	update_xp()
	mob_xp_scaling()
	mob2_xp_scaling()
	player.currentxplevel(xp_level)
	timer.start()

func mob_xp_scaling():
	if xp_level >= 3:
		maxnumber_of_mobs = 30
	elif xp_level >= 5:
		maxnumber_of_mobs = 45
	elif xp_level >= 10:
		maxnumber_of_mobs = 50
	else:
		maxnumber_of_mobs = 25
		

func mob2_xp_scaling():
	if xp_level >= 3:
		maxnumber_of_mobs2 = 7
	elif xp_level >= 7:
		maxnumber_of_mobs2 = 12
	elif xp_level >= 10:
		maxnumber_of_mobs2 = 15
	else:
		maxnumber_of_mobs2 = 5


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

func _on_timer_timeout():
	if number_of_mobs < maxnumber_of_mobs:
		spawn_mob()
	elif number_of_mobs2 < maxnumber_of_mobs2:
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
	mob_xp_scaling()
	mob2_xp_scaling()
	player.currentxplevel(xp_level)
	if number_of_mobs < maxnumber_of_mobs:
		spawn_mob()

func _on_mob_died2():
	number_of_mobs2 -= 1
	points = 3
	ui.update_points(points)
	ui.update_xp(xp_level)
	ui.update_ui()
	update_xp()
	mob_xp_scaling()
	mob2_xp_scaling()
	player.currentxplevel(xp_level)
	if number_of_mobs2 < maxnumber_of_mobs2:
		spawn_mob2()
	
func update_xp():
	xp += 1
	$Player/XPBar.value = xp
	$Player/XPBar.max_value = mobs_to_next_level
	if xp >= mobs_to_next_level:
		xp -= mobs_to_next_level
		xp_level += 1
		mobs_to_next_level += mobs_per_level_increase
		$Player/XPBar.value = xp
		$Player/XPBar.max_value = mobs_to_next_level
		ui.update_xp(xp_level)
		player.currentxplevel(xp_level)
		ui.update_ui()
		mob_xp_scaling()
		mob2_xp_scaling()

func _on_player_health_depleted():
	ui.on_game_over()
