extends Control

var player: Player


func _process(_delta: float) -> void:
	if not player:
		$Label2.text = "no player?"
		return
	
	$Label2.text = str(player.xsm.active_states.keys()) \
		.replace(", ", "\n").replace("[", "").replace("]", "").replace("\"", "") + \
		"\nXvel: " + str(player.velocity.x) + \
		"\nYvel: " + str(player.velocity.y)
