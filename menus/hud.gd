extends Control

@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer
@onready var texture_cam_l: TextureRect = $TextureCamL
@onready var texture_cam_zoom: TextureRect = $TextureCamZoom
@onready var texture_cam_r: TextureRect = $TextureCamR
@onready var timer_second: Timer = $TimerSecond
@onready var label_time: Label = $TimerGraphic/LabelTime
@onready var label_time_low: Label = $TimerGraphic/LabelTimeLow

var SFXs: Dictionary = {
	"got_star": preload("res://audio/sfx/jingles/star_got.ogg"),
	"cancel": preload("res://audio/sfx/system/return.ogg"),
	"time_low": preload("res://audio/sfx/system/time_low.ogg")
}

var tween: Tween
var time_remaining := -1
var time_is_low := false

signal match_timer_timeout


func assign_debug_player(whom: Player) -> void:
	$Debug.player = whom


func _ready() -> void:
	if time_remaining < 0: timer_second.stop()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Utils.set_discord_status(Utils.RPC_STATUS.InMenu)
		sfx.stream = SFXs["cancel"]
		sfx.play()
		Transitionizer.transition(Transitionizer.Styles.DISSOLVE, Transitionizer.Styles.DISSOLVE, true, "res://maps/starting_hall.tscn")


func _on_cam_shifted(direction: int) -> void: # -1 left, 0 stopped, 1 right
	texture_cam_l.visible = direction < 0
	texture_cam_r.visible = direction > 0


func _on_cam_zoomed(zoom_in: bool) -> void:
	if zoom_in:
		if tween and tween.is_running(): tween.stop()
		texture_cam_zoom.modulate = Color(1, 1, 1, 1)
		texture_cam_zoom.texture.region.position.x = 16
	else:
		tween = create_tween()
		tween.tween_property(texture_cam_zoom, "modulate", Color(1, 1, 1, 0), 1)
		texture_cam_zoom.texture.region.position.x = 0


func _on_star_got(new_count: int) -> void:
	sfx.stream = SFXs["got_star"]
	sfx.play()
	$LabelStars.text = "st><" + str(new_count)


func _on_timer_second_timeout() -> void:
	if time_remaining <= 0: 
		timer_second.stop()
		match_timer_timeout.emit()
		return
	
	time_remaining -= 1
	label_time.text = str(time_remaining)
	label_time_low.text = str(time_remaining)
	
	if time_remaining in [1, 3, 5]:
		label_time.visible = false
		label_time_low.visible = true
		sfx.stream = SFXs["time_low"]
		sfx.play()
