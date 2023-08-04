extends Area3D

@export var type: Player.FloorTypes = Player.FloorTypes.NOCODE


func _ready() -> void:
	body_entered.connect(_on_player_body_entered)


func _on_player_body_entered(body: Node3D) -> void:
	if not body is Player: return
	(body as Player).current_floor = type
