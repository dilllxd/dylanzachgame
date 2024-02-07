extends CanvasLayer

class_name UI
signal game_started
var game_points = 0

var xp_level = 0

var username = null

@onready var end_of_game_screen = $end_game/GameOver
@onready var in_game_screen = $in_game/GameUI
@onready var main_menu = $main_menu
@onready var settings = $settings
@onready var save_failed = $save_failed/SaveFailed
@onready var upgrade_screen = $in_game/UpgradeUI
@onready var pause_screen = $in_game/PauseUI

func _ready():
	%HappyBoo.play_idle_animation()
	%Slime.play_walk()

func update_points(points):
	game_points = points
	
func update_xp(level):
	xp_level = level

func update_ui():
	in_game_screen.visible = true
	$in_game/GameUI/in_game_score/points.text = "%d" % game_points
	$in_game/GameUI/in_game_xp/points.text = "%d" % xp_level
	
func on_game_over():
	in_game_screen.visible = false
	end_of_game_screen.visible = true
	$end_game/GameOver/ColorRect/end_game_score/points.text = "%d" % game_points
	$save_failed/SaveFailed/ColorRect/end_game_score/points.text = "%d" % game_points
	
func send_points():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._on_request_completed)
	
	var data_to_send = {"username": username, "gold": game_points}
	var json = JSON.stringify(data_to_send)
	var headers = ["Authorization: testauthorization", "Content-Type: application/json"]
	
	http_request.request("https://gameapi.dylan.lol/api/game/update_gold", headers, HTTPClient.METHOD_POST, json)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		get_tree().reload_current_scene()
	else:
		end_of_game_screen.visible = false
		save_failed.visible = true

func _on_restart_button_pressed():
	send_points()

func _on_play_button_pressed():
	if username == null:
		%Label1.visible = true
		%ProgressBar1.visible = true
	else:
		%Label1.visible = false
		%ProgressBar1.visible = false
		game_started.emit()

func _on_game_game_has_started():
	main_menu.visible = false
	in_game_screen.visible = true

func _on_quit_button_pressed():
	get_tree().quit()

func _on_settings_button_pressed():
	main_menu.visible = false
	settings.visible = true

func _on_back_button_pressed():
	settings.visible = false
	main_menu.visible = true

func _on_save_username_pressed():
	username = $settings/ColorRect/UsernameField.text
	$settings/ColorRect/SaveUsername/Label.text = "Success!"
	%Label1.visible = false
	%ProgressBar1.visible = false
	await get_tree().create_timer(3).timeout
	$settings/ColorRect/SaveUsername/Label.text = "Save Username"

func _on_restart_anyway_button_pressed():
	get_tree().reload_current_scene()

func _on_save_again_button_pressed():
	send_points()

var upgrade_key_pressed = false
var escape_key_pressed = false
var last_toggle_time = 0
var toggle_delay = 0.2 # Adjust this value as needed

func _process(delta):
	last_toggle_time += delta

	if Input.is_action_pressed("ui_upgrade") and in_game_screen.visible:
		if not pause_screen.visible:  # Check if pause menu is not visible
			if last_toggle_time >= toggle_delay:
				if upgrade_screen.visible:
					upgrade_screen.visible = false
					get_tree().paused = false
					print("upgrade set to invisible")
				else:
					upgrade_screen.visible = true
					get_tree().paused = true
					print("upgrade set to visible")
				last_toggle_time = 0

	if Input.is_action_pressed("ui_pause") and in_game_screen.visible:
		if last_toggle_time >= toggle_delay:
			if upgrade_screen.visible:
				upgrade_screen.visible = false
				get_tree().paused = false
				print("upgrade set to invisible")
			elif pause_screen.visible:
				pause_screen.visible = false
				get_tree().paused = false
				print("pause set to invisible")
				escape_key_pressed = false
			else:
				pause_screen.visible = true
				get_tree().paused = true
				print("pause set to visible")
				escape_key_pressed = true
			last_toggle_time = 0


func _on_quit_game_from_pause_pressed():
	get_tree().quit()


func _on_resume_game_from_pause_pressed():
	pause_screen.visible = false
	get_tree().paused = false
