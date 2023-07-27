extends Camera3D

@export_node_path("CharacterBody3D") var player_node: NodePath
@onready var _player: Player = get_node(player_node)


func _process(delta: float) -> void:
	look_at_from_position(_player.global_position - Vector3(0, -0.25, 1), _player.model.position, Vector3.UP, true)
