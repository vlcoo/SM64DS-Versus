extends Control

@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer


func appear() -> void:
	visible = true
	$AnimationPlayer.play("in")


func _on_button_pressed() -> void:
	Utils.set_discord_status(Utils.RPC_STATUS.InMenu)
	sfx.stream = load("res://audio/sfx/system/return.ogg")
	sfx.play()
	Transitionizer.transition(Transitionizer.Styles.DISSOLVE, Transitionizer.Styles.DISSOLVE, true, "res://maps/starting_hall.tscn")
