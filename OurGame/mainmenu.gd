extends CanvasLayer

class_name UI
signal game_started
var game_points = 0

var xp_level = 0

var shotgun_level = 0
var shotgun_level_text = "0"
var shotgun_price = 100
var shotgun_price_text = "100"
var shotgun_upgrade_text = "Upgrade Shotgun"

var speed_boost_level = 0
var speed_boost_level_text = "0"
var speed_boost_price = 50
var speed_boost_price_text = "50"
var speed_boost_upgrade_text = "Upgrade Speed Boost"

var health_upgrade_level = 0
var health_upgrade_level_text = "0"
var health_upgrade_price = 150
var health_upgrade_price_text = "150"
var health_upgrade_upgrade_text = "Upgrade Health"

var life_steal_level = 0
var life_steal_level_text = "0"
var life_steal_price = 150
var life_steal_price_text = "150"
var life_steal_upgrade_text = "Upgrade Life Steal"

var fire_bullets_level = 0
var fire_bullets_level_text = "0"
var fire_bullets_price = 150
var fire_bullets_price_text = "150"
var fire_bullets_upgrade_text = "Upgrade Fire Bullets"

var more_damage_level = 0
var more_damage_level_text = "0"
var more_damage_price = 150
var more_damage_price_text = "150"
var more_damage_upgrade_text = "Upgrade More Damage"

var after_purchase_points = null

var music_pos = 0.0

var username = null

@onready var username_label = get_node("/root/Game/Player/Username")
@onready var end_of_game_screen = $end_game/GameOver
@onready var in_game_screen = $in_game/GameUI
@onready var main_menu = $main_menu/MenuUI
@onready var settings = $settings/SettingsUI
@onready var save_failed = $save_failed/SaveFailed
@onready var upgrade_screen = $in_game/UpgradeUI
@onready var pause_screen = $in_game/PauseUI
@onready var gun = get_node("/root/Game/Player/Gun")
@onready var player = get_node("/root/Game/Player")

const EXPORT_CONFIG_URL := "https://raw.githubusercontent.com/dilllxd/dylanzachgame/main/OurGame/version.cfg"
const EXPORT_CONFIG_METADATA_SECTION := "metadata"

var version = null

var leaderboard_labels = []

func _ready():
	load_game_version()
	%HappyBoo.play_idle_animation()
	%Slime.play_walk()
	
	for i in range(1, 12):  # Assuming 11 labels numbered 1 through 11
		var label_node_path = "/root/Game/UI/in_game/GameUI/leaderboard/VBoxContainer/" + str(i)
		var label_node = get_node(label_node_path)
		if label_node:
			leaderboard_labels.append(label_node)
		else:
			print("Label node not found:", i)
			
	update_leaderboard()
	
	var update_timer = Timer.new()
	update_timer.wait_time = 60
	update_timer.one_shot = false
	update_timer.connect("timeout", update_leaderboard)
	add_child(update_timer)
	update_timer.start()

func load_game_version():
	var version_request = HTTPRequest.new()
	add_child(version_request)
	version_request.request_completed.connect(self._on_version_request_completed)

	# Perform a GET request to fetch leaderboard data.
	var error = version_request.request("https://raw.githubusercontent.com/dilllxd/dylanzachgame/main/OurGame/version.cfg")
	if error != OK:
		print("An error occurred in the HTTP request.")

func _on_version_request_completed(result, response_code, headers, body):
	if result != OK:
		print("Failed to fetch game metadata")
		return
	else:
		var body_str = body.get_string_from_utf8()  # Convert PackedByteArray to string
		var version_line = body_str.strip_edges().split("=")  # Splitting into key-value pair
		if version_line.size() > 1:
			var version = version_line[1].strip_edges()  # Extracting version string
			version = version.substr(1, version.length() - 2)  # Removing surrounding quotes
			$main_menu/MenuUI/ColorRect/VersionLabel.text = version
			$in_game/GameUI/Version.text = version
		else:
			print("Version information not found in metadata")

func update_points(points):
	game_points += points
	update_leaderboard()
	
func update_xp(level):
	xp_level = level

func update_ui():
	$in_game/GameUI/in_game_score/score.text = "Points: %d" % game_points
	$in_game/GameUI/in_game_xp/xp.text = str(xp_level)
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/Points.text = "Points: %d" % game_points
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/XP.text = "XP Level: %d" % xp_level
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeShotgun/LevelLabel.text = "Current Level: " + shotgun_level_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeShotgun/UpgradePriceLabel.text = "Upgrade Price: " + shotgun_price_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeSpeed/LevelLabel.text = "Current Level: " + speed_boost_level_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeSpeed/UpgradePriceLabel.text = "Upgrade Price: " + speed_boost_price_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeHealth/LevelLabel.text = "Current Level: " + health_upgrade_level_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeHealth/UpgradePriceLabel.text = "Upgrade Price: " + health_upgrade_price_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeLifeSteal/LevelLabel.text = "Current Level: " + life_steal_level_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeLifeSteal/UpgradePriceLabel.text = "Upgrade Price: " + life_steal_price_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeMoreDamage/LevelLabel.text = "Current Level: " + more_damage_level_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeMoreDamage/UpgradePriceLabel.text = "Upgrade Price: " + more_damage_price_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeFireBullets/LevelLabel.text = "Current Level: " + fire_bullets_level_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeFireBullets/UpgradePriceLabel.text = "Upgrade Price: " + fire_bullets_price_text
	
	
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeShotgun/TextLabel.text = shotgun_upgrade_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeSpeed/TextLabel.text = speed_boost_upgrade_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeHealth/TextLabel.text = health_upgrade_upgrade_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeLifeSteal/TextLabel.text = life_steal_upgrade_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeMoreDamage/TextLabel.text = more_damage_upgrade_text
	$in_game/UpgradeUI/Control/ScrollContainer/ColorRect/UpgradeFireBullets/TextLabel.text = fire_bullets_upgrade_text
	
func on_game_over():
	in_game_screen.visible = false
	end_of_game_screen.visible = true
	$end_game/GameOver/ColorRect/score.text = "Points: %d" % game_points
	$save_failed/SaveFailed/ColorRect/score.text = "Points: %d" % game_points
	
func send_points():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._on_request_completed)
	
	var data_to_send = {"username": username, "gold": game_points}
	var json = JSON.stringify(data_to_send)
	var headers = ["Authorization: testauthorization", "Content-Type: application/json"]
	
	http_request.request("https://gameapi.dylan.lol/api/game/update_gold", headers, HTTPClient.METHOD_POST, json)

func _on_request_completed(_result, response_code, _headers, _body):
	if response_code == 200:
		get_tree().reload_current_scene()
		$PlayingAudioLoop.stop()
		music_pos = 0.0
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
		in_game_screen.visible = true
		game_started.emit()
		$PlayingAudioLoop.play()

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
	if $settings/SettingsUI/ColorRect/UsernameField.text == "":
		var hardware_identifier = generate_hardware_identifier()
		username = "Player_" + hardware_identifier
		username_label.text = username
		update_leaderboard()
		$settings/SettingsUI/ColorRect/SaveUsername/Label.text = "Success!"
		%Label1.visible = false
		%ProgressBar1.visible = false
		await get_tree().create_timer(3).timeout
		$settings/SettingsUI/ColorRect/SaveUsername/Label.text = "Save Username"
	else:
		username = $settings/SettingsUI/ColorRect/UsernameField.text
		username_label.text = username
		update_leaderboard()
		$settings/SettingsUI/ColorRect/SaveUsername/Label.text = "Success!"
		%Label1.visible = false
		%ProgressBar1.visible = false
		await get_tree().create_timer(3).timeout
		$settings/SettingsUI/ColorRect/SaveUsername/Label.text = "Save Username"

func generate_hardware_identifier():
	var hw_identifier = OS.get_name() + OS.get_unique_id()
	var hashed_identifier = hash(hw_identifier)
	return "%x" % hashed_identifier

func _on_restart_anyway_button_pressed():
	get_tree().reload_current_scene()

func _on_save_again_button_pressed():
	send_points()

var upgrade_key_pressed = false
var escape_key_pressed = false
var last_toggle_time = 0
var toggle_delay = 0.2 # Adjust this value as needed

func _physics_process(delta):
	last_toggle_time += delta
	update_ui()

	if Input.is_action_pressed("ui_upgrade") and in_game_screen.visible:
		if not pause_screen.visible:  # Check if pause menu is not visible
			if last_toggle_time >= toggle_delay:
				if upgrade_screen.visible:
					upgrade_screen.visible = false
					get_tree().paused = false
					$PlayingAudioLoop.volume_db = 0
				else:
					upgrade_screen.visible = true
					get_tree().paused = true
					$PlayingAudioLoop.volume_db = -15
				last_toggle_time = 0

	if Input.is_action_pressed("ui_pause") and in_game_screen.visible:
		if last_toggle_time >= toggle_delay:
			if upgrade_screen.visible:
				upgrade_screen.visible = false
				get_tree().paused = false
				$PlayingAudioLoop.volume_db = 0
			elif pause_screen.visible:
				pause_screen.visible = false
				get_tree().paused = false
				$PlayingAudioLoop.volume_db = 0
				escape_key_pressed = false
			else:
				pause_screen.visible = true
				get_tree().paused = true
				$PlayingAudioLoop.volume_db = -15
				escape_key_pressed = true
			last_toggle_time = 0

func _on_quit_game_from_pause_pressed():
	get_tree().quit()

func _on_resume_game_from_pause_pressed():
	pause_screen.visible = false
	$PlayingAudioLoop.volume_db = 0
	get_tree().paused = false

func _on_upgrade_shotgun_pressed():
	if shotgun_level == 0:
		if xp_level >= 5:
			if game_points >= shotgun_price:
				game_points -= shotgun_price
				shotgun_level_text = "1"
				shotgun_level = 1
				gun.upgradeshotgun(shotgun_level)
				shotgun_price = 200
				shotgun_price_text = "200"
				shotgun_upgrade_text = "Upgrade Shotgun"
				update_ui()
			else:
				shotgun_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				shotgun_upgrade_text = "Upgrade Shotgun"
		else:
			shotgun_upgrade_text = "You are not high enough level! Level Required: 5"
			await get_tree().create_timer(3).timeout
			shotgun_upgrade_text = "Upgrade Shotgun"
	elif shotgun_level == 1:
		if xp_level >= 15:
			if game_points >= shotgun_price:
				game_points -= shotgun_price
				shotgun_level_text = "Max (2)"
				shotgun_level = 2
				gun.upgradeshotgun(shotgun_level)
				shotgun_price_text = "None"
				shotgun_price = 0
				shotgun_upgrade_text = "You are at max level!"
				update_ui()
			else:
				shotgun_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				shotgun_upgrade_text = "Upgrade Shotgun"
		else:
			shotgun_upgrade_text = "You are not high enough level! Level Required: 15"
			await get_tree().create_timer(3).timeout
			shotgun_upgrade_text = "Upgrade Shotgun"
	else:
		pass
			
func _on_upgrade_speed_pressed():
	if speed_boost_level == 0:
		if xp_level >= 5:
			if game_points >= speed_boost_price:
				game_points -= speed_boost_price
				speed_boost_level_text = "1"
				speed_boost_level = 1
				player.upgradespeed(speed_boost_level)
				speed_boost_price_text = "100"
				speed_boost_price = 100
				speed_boost_upgrade_text = "Upgrade Speed Boost"
				update_ui()
			else:
				speed_boost_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				speed_boost_upgrade_text = "Upgrade Speed Boost"
		else:
			speed_boost_upgrade_text = "You are not high enough level! Level Required: 5"
			await get_tree().create_timer(3).timeout
			speed_boost_upgrade_text = "Upgrade Speed Boost"
	elif speed_boost_level == 1:
		if xp_level >= 7:
			if game_points >= speed_boost_price:
				game_points -= speed_boost_price
				speed_boost_level_text = "2"
				speed_boost_level = 2
				player.upgradespeed(speed_boost_level)
				speed_boost_price_text = "200"
				speed_boost_price = 200
				speed_boost_upgrade_text = "Upgrade Speed Boost"
				update_ui()
			else:
				speed_boost_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				speed_boost_upgrade_text = "Upgrade Speed Boost"
		else:
			speed_boost_upgrade_text = "You are not high enough level! Level Required: 7"
			await get_tree().create_timer(3).timeout
			speed_boost_upgrade_text = "Upgrade Speed Boost"
	elif speed_boost_level == 2:
		if xp_level >= 15:
			if game_points >= speed_boost_price:
				game_points -= speed_boost_price
				speed_boost_level_text = "Max (3)"
				speed_boost_level = 3
				player.upgradespeed(speed_boost_level)
				speed_boost_price_text = "None"
				speed_boost_price = 0
				speed_boost_upgrade_text = "You are at max level!"
				update_ui()
			else:
				speed_boost_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				speed_boost_upgrade_text = "Upgrade Speed Boost"
		else:
			speed_boost_upgrade_text = "You are not high enough level! Level Required: 15"
			await get_tree().create_timer(3).timeout
			speed_boost_upgrade_text = "Upgrade Speed Boost"
	else:
		pass

func _on_upgrade_health_pressed():
	if health_upgrade_level == 0:
		if xp_level >= 7:
			if game_points >= health_upgrade_price:
				game_points -= health_upgrade_price
				health_upgrade_level_text = "1"
				health_upgrade_level = 1
				player.upgradehealth(health_upgrade_level)
				health_upgrade_price = 200
				health_upgrade_price_text = "200"
				health_upgrade_upgrade_text = "Upgrade Health"
				update_ui()
			else:
				health_upgrade_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				health_upgrade_upgrade_text = "Upgrade Health"
		else:
			health_upgrade_upgrade_text = "You are not high enough level! Level Required: 7"
			await get_tree().create_timer(3).timeout
			health_upgrade_upgrade_text = "Upgrade Health"
	elif health_upgrade_level == 1:
		if xp_level >= 10:
			if game_points >= health_upgrade_price:
				game_points -= health_upgrade_price
				health_upgrade_level_text = "Max (2)"
				health_upgrade_level = 2
				player.upgradehealth(health_upgrade_level)
				health_upgrade_price_text = "None"
				health_upgrade_price = 0
				health_upgrade_upgrade_text = "You are at max level!"
				update_ui()
			else:
				health_upgrade_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				health_upgrade_upgrade_text = "Upgrade Health"
		else:
			health_upgrade_upgrade_text = "You are not high enough level! Level Required: 10"
			await get_tree().create_timer(3).timeout
			health_upgrade_upgrade_text = "Upgrade Health"
	else:
		pass


func _on_upgrade_life_steal_pressed():
	if life_steal_level == 0:
		if xp_level >= 5:
			if game_points >= life_steal_price:
				game_points -= life_steal_price
				life_steal_level_text = "1"
				life_steal_level = 1
				player.upgradelifesteal(life_steal_level)
				life_steal_price_text = "100"
				life_steal_price = 100
				life_steal_upgrade_text = "Upgrade Life Steal"
				update_ui()
			else:
				life_steal_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				life_steal_upgrade_text = "Upgrade Life Steal"
		else:
			life_steal_upgrade_text = "You are not high enough level! Level Required: 5"
			await get_tree().create_timer(3).timeout
			life_steal_upgrade_text = "Upgrade Life Steal"
	elif life_steal_level == 1:
		if xp_level >= 7:
			if game_points >= life_steal_price:
				game_points -= life_steal_price
				life_steal_level_text = "2"
				life_steal_level = 2
				player.upgradelifesteal(life_steal_level)
				life_steal_price_text = "200"
				life_steal_price = 200
				life_steal_upgrade_text = "Upgrade Life Steal"
				update_ui()
			else:
				life_steal_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				life_steal_upgrade_text = "Upgrade Life Steal"
		else:
			life_steal_upgrade_text = "You are not high enough level! Level Required: 7"
			await get_tree().create_timer(3).timeout
			life_steal_upgrade_text = "Upgrade Life Steal"
	elif life_steal_level == 2:
		if xp_level >= 15:
			if game_points >= life_steal_price:
				game_points -= life_steal_price
				life_steal_level_text = "Max (3)"
				life_steal_level = 3
				player.upgradelifesteal(life_steal_level)
				life_steal_price_text = "None"
				life_steal_price = 0
				life_steal_upgrade_text = "You are at max level!"
				update_ui()
			else:
				life_steal_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				life_steal_upgrade_text = "Upgrade Life Steal"
		else:
			life_steal_upgrade_text = "You are not high enough level! Level Required: 15"
			await get_tree().create_timer(3).timeout
			life_steal_upgrade_text = "Upgrade Life Steal"
	else:
		pass


func _on_upgrade_more_damage_pressed():
	if more_damage_level == 0:
		if xp_level >= 5:
			if game_points >= more_damage_price:
				game_points -= more_damage_price
				more_damage_level_text = "1"
				more_damage_level = 1
				more_damage_price_text = "100"
				more_damage_price = 100
				more_damage_upgrade_text = "Upgrade More Damage"
				update_ui()
			else:
				more_damage_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				more_damage_upgrade_text = "Upgrade More Damage"
		else:
			more_damage_upgrade_text = "You are not high enough level! Level Required: 5"
			await get_tree().create_timer(3).timeout
			more_damage_upgrade_text = "Upgrade More Damage"
	elif more_damage_level == 1:
		if xp_level >= 7:
			if game_points >= more_damage_price:
				game_points -= more_damage_price
				more_damage_level_text = "2"
				more_damage_level = 2
				more_damage_price_text = "200"
				more_damage_price = 200
				more_damage_upgrade_text = "Upgrade More Damage"
				update_ui()
			else:
				more_damage_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				more_damage_upgrade_text = "Upgrade More Damage"
		else:
			more_damage_upgrade_text = "You are not high enough level! Level Required: 7"
			await get_tree().create_timer(3).timeout
			more_damage_upgrade_text = "Upgrade More Damage"
	elif more_damage_level == 2:
		if xp_level >= 15:
			if game_points >= more_damage_price:
				game_points -= more_damage_price
				more_damage_level_text = "Max (3)"
				more_damage_level = 3
				more_damage_price_text = "None"
				more_damage_price = 0
				more_damage_upgrade_text = "You are at max level!"
				update_ui()
			else:
				more_damage_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				more_damage_upgrade_text = "Upgrade More Damage"
		else:
			more_damage_upgrade_text = "You are not high enough level! Level Required: 15"
			await get_tree().create_timer(3).timeout
			more_damage_upgrade_text = "Upgrade More Damage"
	else:
		pass


func _on_upgrade_fire_bullets_pressed():
	if fire_bullets_level == 0:
		if xp_level >= 1:
			if game_points >= fire_bullets_price:
				game_points -= fire_bullets_price
				fire_bullets_level_text = "1"
				fire_bullets_level = 1
				fire_bullets_price_text = "100"
				fire_bullets_price = 100
				fire_bullets_upgrade_text = "Upgrade Fire Bullets"
				update_ui()
			else:
				fire_bullets_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				fire_bullets_upgrade_text = "Upgrade Fire Bullets"
		else:
			fire_bullets_upgrade_text = "You are not high enough level! Level Required: 5"
			await get_tree().create_timer(3).timeout
			fire_bullets_upgrade_text = "Upgrade Fire Bullets"
	elif fire_bullets_level == 1:
		if xp_level >= 7:
			if game_points >= fire_bullets_price:
				game_points -= fire_bullets_price
				fire_bullets_level_text = "2"
				fire_bullets_level = 2
				fire_bullets_price_text = "200"
				fire_bullets_price = 200
				fire_bullets_upgrade_text = "Upgrade Fire Bullets"
				update_ui()
			else:
				fire_bullets_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				fire_bullets_upgrade_text = "Upgrade Fire Bullets"
		else:
			fire_bullets_upgrade_text = "You are not high enough level! Level Required: 7"
			await get_tree().create_timer(3).timeout
			fire_bullets_upgrade_text = "Upgrade Fire Bullets"
	elif fire_bullets_level == 2:
		if xp_level >= 15:
			if game_points >= fire_bullets_price:
				game_points -= fire_bullets_price
				fire_bullets_level_text = "Max (3)"
				fire_bullets_level = 3
				fire_bullets_price_text = "None"
				fire_bullets_price = 0
				fire_bullets_upgrade_text = "You are at max level!"
				update_ui()
			else:
				fire_bullets_upgrade_text = "You do not have enough points!"
				await get_tree().create_timer(3).timeout
				fire_bullets_upgrade_text = "Upgrade Fire Bullets"
		else:
			fire_bullets_upgrade_text = "You are not high enough level! Level Required: 15"
			await get_tree().create_timer(3).timeout
			fire_bullets_upgrade_text = "Upgrade Fire Bullets"
	else:
		pass
	
func update_leaderboard():
	#print("Updating leaderboard...")
	var http_request2 = HTTPRequest.new()
	add_child(http_request2)
	http_request2.request_completed.connect(self._on_request_completed2)

	# Perform a GET request to fetch leaderboard data.
	var error = http_request2.request("https://gameapi.dylan.lol/api/game/leaderboard")
	if error != OK:
		print("An error occurred in the HTTP request.")

func _on_request_completed2(_result, response_code, _headers, body):
	#print("Request completed with response code:", response_code)
	if response_code == 200:
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var leaderboard_data = json.get_data()

		if leaderboard_data:
			leaderboard_data.sort_custom(_sort_players)
			update_leaderboard_ui(leaderboard_data)
		else:
			print("Failed to parse leaderboard data.")
	else:
		print("Failed to fetch leaderboard data")

func update_leaderboard_ui(leaderboard_data):
	var player_position = len(leaderboard_data) + 1  # Default to the next position after all existing players

	# Sort leaderboard data in descending order based on gold
	leaderboard_data.sort_custom(_sort_players)

	# Find the player's position in the sorted leaderboard data
	for i in range(min(10, len(leaderboard_data))):
		if game_points > leaderboard_data[i]["gold"]:
			player_position = i + 1
			break

	# Display leaderboard data on labels 1 to 10
	for i in range(10):
		if i < len(leaderboard_data):
			leaderboard_labels[i].text = str(i + 1) + ". " + leaderboard_data[i]["username"] + ": " + str(leaderboard_data[i]["gold"])
		else:
			leaderboard_labels[i].text = str(i + 1) + ". Nobody!"

	# Display player's score and dynamic position
	leaderboard_labels[10].text = str(player_position) + ". " + str(username) + ": " + str(game_points)

func _sort_players(a, b):
	return b["gold"] - a["gold"]

func _on_playing_audio_loop_finished():
	$PlayingAudioLoop.play()
