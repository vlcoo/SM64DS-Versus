extends Node

const CONFIG_PATH: String = "user://savedata.ini"
enum RPC_STATUS {InMenu, InGame}

var config: ConfigFile = ConfigFile.new()

var player_nickname: String = "noname"
var benchmark_mode: bool = false


func _ready() -> void:
	tree_exiting.connect(_on_tree_exiting)
	
	var err: Error = config.load(CONFIG_PATH)
	if err != OK: config = ConfigFile.new()
	
	benchmark_mode = ProjectSettings.get_setting("application/run/benchmark_mode", false)


func _on_tree_exiting() -> void:
	config.save(CONFIG_PATH)


func get_random_nick() -> String:
	var n := "" 
	while n.length() < 7:
		n += ["a", "e", "i", "o", "u"].pick_random()
	return n.capitalize()


func set_discord_status(status: RPC_STATUS, map_name: String = "", match_timer: int = 0) -> void:
	pass
	
	#match status:
		#RPC_STATUS.InMenu:
			#discord_sdk.details = "Browsing the Main Menu"
			#discord_sdk.state = ""
			#discord_sdk.large_image = "menu"
			#discord_sdk.end_timestamp = 0
		#RPC_STATUS.InGame:
			#discord_sdk.details = "Playing an offline match"
			#discord_sdk.state = map_name.replace("_", " ").capitalize()
			#discord_sdk.large_image = map_name
			#if match_timer > 0:
				#discord_sdk.end_timestamp = int(Time.get_unix_time_from_system()) + match_timer
	#
	#discord_sdk.refresh()
