extends Control


func _ready() -> void:
	randomize()
	$VBoxContainer/LabelLogo.text = get_company_name()


func get_company_name() -> String:
	var c: String = "N"
	c += ["i", "l"][randi() % 2]
	c += ["n", "m"][randi() % 2]
	c += ["id", "t", "l"][randi() % 3]
	c += ["e", "da", "o"][randi() % 3]
	c += ["n", "m"][randi() % 2]
	c += "dd" if c != "Ninten" else "t"
	c += ["e", "a", "o"][randi() % 3]

	return c


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	Transitionizer.transition(Transitionizer.Styles.DISSOLVE, Transitionizer.Styles.DISSOLVE, true, "res://menus/title.tscn")
