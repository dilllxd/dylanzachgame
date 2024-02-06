extends CanvasLayer

class_name UI
signal game_started
var game_points = 0

@onready var end_of_game_screen = $end_game/GameOver

func _ready():
	var username = "Dilllxd"
	var gold = game_points

	var data_to_send = {
	  "username": username,
	  "gold": gold
	}

	var json = JSON.stringify(data_to_send)

	var headers = [
	  "Authorization: testauthorization",
	  "Content-Type: application/json"
	]

	$HTTPRequest.request("https://gameapi.dylan.lol/api/game/update_gold", headers, HTTPClient.METHOD_POST, json)

func update_points(points):
	game_points = points
	
func on_game_over():
	end_of_game_screen.visible = true
	$end_game/GameOver/ColorRect/end_game_score/points.text = "%d" % game_points
	
func _on_restart_button_pressed():
	get_tree().reload_current_scene()
