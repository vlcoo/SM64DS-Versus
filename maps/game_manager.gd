extends Node

@onready var hud: Control = $GameHUD
@onready var player_spawn: Marker3D = $"3D/PlayerSpawn"

var current_player: Player


func _ready() -> void:
	%DirLightMain.shadow_enabled = Utils.config.get_value("settings", "graphics") != 0
	
	spawn_player()


func spawn_player(controlled: bool = true) -> void:
	assert(has_node("3D/PlayerSpawn"), "Map has no Player spawnpoint!")
	
	current_player = load("res://player/player.tscn").instantiate()
	current_player.cam_shifted.connect(hud._on_cam_shifted)
	current_player.cam_zoomed.connect(hud._on_cam_zoomed)
	current_player.got_star.connect(hud._on_star_got)
	current_player.x_locked = not controlled
	current_player.y_locked = not controlled
	$"3D".add_child(current_player)
	current_player.global_position = player_spawn.global_position
	
	hud.assign_debug_player(current_player)
