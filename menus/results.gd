extends Control

@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer

var SFXs: Dictionary = {
	"time_up": preload("res://audio/sfx/system/time_up.ogg"),
	"return": preload("res://audio/sfx/system/return.ogg")
}


func appear() -> void:
	visible = true
	$AnimationPlayer.play("in")
	sfx.stream = SFXs["time_up"]
	sfx.play()


func _on_button_pressed() -> void:
	Utils.set_discord_status(Utils.RPC_STATUS.InMenu)
	sfx.stream = SFXs["return"]
	sfx.play()
	Transitionizer.transition(Transitionizer.Styles.DISSOLVE, Transitionizer.Styles.DISSOLVE, true, "res://maps/starting_hall.tscn")
