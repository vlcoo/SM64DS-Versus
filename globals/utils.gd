extends Node

const CONFIG_PATH: String = "user://savedata.ini"

var config: ConfigFile = ConfigFile.new()

var player_nickname: String = "noname"


func _ready() -> void:
	tree_exiting.connect(_on_tree_exiting)
	
	var err: Error = config.load(CONFIG_PATH)
	if err != OK: config = ConfigFile.new()


func _on_tree_exiting() -> void:
	config.save(CONFIG_PATH)


func get_random_nick() -> String:
	var n := "" 
	while n.length() < 7:
		n += ["a", "e", "i", "o", "u"].pick_random()
	return n.capitalize()
