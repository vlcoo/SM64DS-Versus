extends Node

const CONFIG_PATH: String = "user://savedata.ini"
enum RPC_STATUS {InMenu, InGame}

var config: ConfigFile = ConfigFile.new()

var player_nickname: String = "noname"


func _ready() -> void:
	tree_exiting.connect(_on_tree_exiting)
	
	var err: Error = config.load(CONFIG_PATH)
	if err != OK: config = ConfigFile.new()
	discord_sdk.app_id = 1136244950850351165


func _on_tree_exiting() -> void:
	config.save(CONFIG_PATH)


func get_random_nick() -> String:
	var n := "" 
	while n.length() < 7:
		n += ["a", "e", "i", "o", "u"].pick_random()
	return n.capitalize()


func set_discord_status(status: RPC_STATUS, map_name: String = "") -> void:
	match status:
		RPC_STATUS.InMenu:
			discord_sdk.details = "Browsing the Main Menu"
			discord_sdk.state = ""
			discord_sdk.large_image = "menu"
		RPC_STATUS.InGame:
			discord_sdk.details = "Playing an offline match"
			discord_sdk.state = map_name.replace("_", " 	 ").capitalize()
			discord_sdk.large_image = map_name
	
	discord_sdk.refresh()
