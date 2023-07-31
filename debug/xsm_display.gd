extends Control

var player: Player


func _process(_delta: float) -> void:
	if not player:
		$Label2.text = "no player?"
		return
	
	$Label2.text = str(player.xsm.active_states.keys()) \
		.replace(", ", "\n").replace("[", "").replace("]", "").replace("\"", "") + \
		"\nXvel: " + str((player.velocity * Vector3(1, 0, 1)).length()) + (" locked" if player.x_locked else "") + \
		"\nYvel: " + str(player.velocity.y) + (" locked" if player.y_locked else "")
