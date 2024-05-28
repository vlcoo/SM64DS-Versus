extends Control


func _ready() -> void:
	randomize()
	$VBoxContainer/LabelLogo.text = get_company_name()
	Utils.set_discord_status(Utils.RPC_STATUS.InMenu)


func get_company_name() -> String:
	var c: String = "N"
	c += ["i", "l"][randi() % 2]
	c += ["n", "m"][randi() % 2]
	c += ["i", "t", "l"][randi() % 3]
	c += ["e", "a", "o"][randi() % 3]
	c += ["n", "m"][randi() % 2]
	c += "d" if c != "Ninten" else "t"
	c += ["e", "a", "o"][randi() % 3]

	return c


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	Transitionizer.transition(
		Transitionizer.Styles.DISSOLVE, Transitionizer.Styles.DISSOLVE, true, 
		"res://debug/benchmarker.tscn" if Utils.benchmark_mode else "res://menus/title.tscn"
	)
