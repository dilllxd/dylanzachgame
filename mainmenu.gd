extends CanvasLayer

class_name UI
signal game_started
var game_points = 0

var username = null

@onready var end_of_game_screen = $end_game/GameOver
@onready var in_game_screen = $in_game/GameUI
@onready var main_menu = $main_menu
@onready var settings = $settings

func _ready():
	pass

func update_points(points):
	game_points = points
	
func update_ui():
	in_game_screen.visible = true
	$in_game/GameUI/in_game_score/points.text = "%d" % game_points
	
func on_game_over():
	in_game_screen.visible = false
	end_of_game_screen.visible = true
	$end_game/GameOver/ColorRect/end_game_score/points.text = "%d" % game_points
	
func send_points():
	var data_to_send = {"username": username, "gold": game_points}
	var json = JSON.stringify(data_to_send)
	var headers = ["Authorization: testauthorization", "Content-Type: application/json"]	
	$HTTPRequest.request("https://gameapi.dylan.lol/api/game/update_gold", headers, HTTPClient.METHOD_POST, json)

func _on_restart_button_pressed():
	# this all needs to be reworked into a statement that listens for when the http request is sent, then reloads
	send_points()
	await get_tree().create_timer(1).timeout 
	get_tree().reload_current_scene()

func _on_play_button_pressed():
	# need to check for username being set, if not set then make display message about setting it
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
