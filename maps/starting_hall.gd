extends Node

var SFXs: Dictionary = {
	"accept": preload("res://audio/sfx/system/accept.ogg"),
	"special": preload("res://audio/sfx/system/special_middle.ogg"),
	"return": preload("res://audio/sfx/system/return.ogg"),
	"buzzer": preload("res://audio/sfx/system/buzzer.ogg")
}

@onready var btn_start: Button = $Control/ContainerPlayerList/Button
@onready var container_player_list: VBoxContainer = $Control/ContainerPlayerList
@onready var container_map_selector: VBoxContainer = $Control/ContainerMapSelector
@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer2
@onready var timer_button: Timer = $Control/TimerButton


var selected_map: String
var regex_invalid_name: RegEx


func _ready() -> void:
	regex_invalid_name = RegEx.new()
	regex_invalid_name.compile("[^A-Za-z0-9]+")
	
	$Control/ContainerPlayerList/Panel/LineEdit.text = Utils.config.get_value("player", "nickname", Utils.get_random_nick())


func _on_button_pressed() -> void:
	sfx.stream = SFXs["accept"]
	sfx.play()
	timer_button.start()
	await timer_button.timeout
	container_map_selector.visible = true
	container_player_list.visible = false
	$Control/ContainerPlayerList/Button.button_pressed = false
	
	var n: String = $Control/ContainerPlayerList/Panel/LineEdit.text
	Utils.config.set_value("player", "nickname", n)
	Utils.player_nickname = n


func _on_button_2_pressed() -> void:
	sfx.stream = SFXs["return"]
	sfx.play()
	Transitionizer.transition(Transitionizer.Styles.DISSOLVE, Transitionizer.Styles.DISSOLVE, true, "res://menus/title.tscn")


func _on_button_3_pressed() -> void:
	sfx.stream = SFXs["return"]
	sfx.play()
	timer_button.start()
	await timer_button.timeout
	container_map_selector.visible = false
	container_player_list.visible = true
	$Control/ContainerMapSelector/Button.button_pressed = false


func _on_map_selected(map_name: String) -> void:
	sfx.stream = SFXs["special"]
	sfx.play()
	selected_map = map_name
	$AnimationPlayer.play("fadeout_ui")


func _begin_map_transition() -> void:
	Transitionizer.transition(Transitionizer.Styles.DISSOLVE, Transitionizer.Styles.DISSOLVE, true, "res://maps/" + selected_map + ".tscn", true)


func _on_line_edit_text_changed(new_text: String) -> void:
	var result: RegExMatch = regex_invalid_name.search(new_text)
	if result:
		sfx.stream = SFXs["buzzer"]
		sfx.play()
		$Control/ContainerPlayerList/Panel/LineEdit.text = new_text.replace(result.get_string(), "")
		return
	
	if new_text.is_empty(): 
		btn_start.disabled = true
		return
	
	btn_start.disabled = false
