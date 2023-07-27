@icon("res://debug/y_icon.png")
class_name Player
extends CharacterBody3D

var GRAVITY: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export_group("Movement physics")
## Horizontal speed.
@export var SPEED: float
## Velocity of jump impulse.
@export var JUMP_STRENGTH: float
## Velocity multiplier of the double jump.
@export var JUMP2_MULTIPLIER: float
## Velocity multiplier of the triple jump.
@export var JUMP3_MULTIPLIER: float
## Minimum distance to jump before it can be cut short by releasing the jump button.
@export var JUMP_INTERRUPT_THRESHOLD: float
## Downwards velocity of a groundpound.
@export var GROUNDPOUND_FORCE: float
@export_group("Timers")
## Time in seconds the player has to perform a double jump after touching the floor.
@export var JUMP2_TIME: float
## Time in seconds the player needs to be falling for to receive fall damage.
@export var LONG_FALL_TIME: float
## Time in seconds the player will wait in mid-air before dropping on a groundpound.
@export var GROUNDPOUND_IMPACT_TIME: float
@export_group("Camera settings")
## Speed of the camera rotation with the shoulder buttons.
@export var CAM_ROTATION_SPEED: float = 1.0
## If enabled, this player will be controllable and the camera will follow them.
@export var camera_follow: bool = true

static var SFXs: Dictionary = {
	"step_jump": preload("res://audio/sfx/environment/step_ground_jump.ogg"),
	"step_land": preload("res://audio/sfx/environment/step_ground_land.ogg"),
	"star_touched": preload("res://audio/sfx/jingles/star_touched.ogg")
}

@onready var animation: AnimationTree = $AnimationTree
@onready var model: Skeleton3D = $Model
@onready var xsm: StateRegions = $XSM
@onready var sfx: AudioStreamPlayer3D = $SFX
@onready var sfx_steps: AudioStreamPlayer3D = $SFXSteps
@onready var particles: GPUParticles3D = $GPUParticles3D

@onready var cam: Camera3D = $SpringArmPivot/SpringArm3D/Camera3D
@onready var cam_pivot: Node3D = $SpringArmPivot
@onready var cam_arm: SpringArm3D = $SpringArmPivot/SpringArm3D
@onready var cam_sfx: AudioStreamPlayer = $SpringArmPivot/CamShiftSFX
var _is_cam_zoomed: bool = false

var x_locked: bool = false
var y_locked: bool = false

var star_count: int = 0

signal cam_shifted(direction: int)
signal cam_zoomed(zoom_in: bool)
signal got_star(new_count: int)


func _ready() -> void:
	for file in DirAccess.open("res://audio/sfx/voice/").get_files():
		if ".import" in file or not "y_" in file: continue
		SFXs[file.replace(".ogg", "").replace("y_", "")] = load("res://audio/sfx/voice/" + file)
	
	$SpringArmPivot/SpringArm3D/Camera3D.current = camera_follow
	$Nametag.visible = camera_follow
	xsm.disabled = not camera_follow


func start_picture_anim() -> void:
	xsm.disabled = true
	animation.active = false
	$AnimationPlayer.play("anims_nsmb/jump")
	play_sfx("couple")


func play_sfx(which: String, is_not_voice: bool = false) -> void:
	assert(which in SFXs.keys(), "Tried to play SFX that doesn't exist.")
	if is_not_voice:
		sfx_steps.stream = SFXs[which]
		sfx_steps.play()
	else:
		sfx.stream = SFXs[which]
		sfx.play()


func _process(delta: float) -> void:
	if not camera_follow: return
	
	if Input.is_action_just_pressed("cam_zoom"):
		$SpringArmPivot/CamAnimations.play("zoom_out" if _is_cam_zoomed else "zoom_in")
		_is_cam_zoomed = not _is_cam_zoomed
		cam_zoomed.emit(_is_cam_zoomed)
		$Nametag.visible = not _is_cam_zoomed
	
	if Input.is_action_just_released("cam_left") or Input.is_action_just_released("cam_right"):
		cam_sfx.stop()
		cam_shifted.emit(0)
	if Input.is_action_just_pressed("cam_left") or Input.is_action_just_pressed("cam_right"):
		cam_sfx.play()
	
	var rotate_strength: float = Input.get_axis("cam_left", "cam_right")
	if rotate_strength == 0: return
	cam_shifted.emit(rotate_strength)
	cam_sfx.pitch_scale = max(abs(rotate_strength), 0.5)
	cam_pivot.rotate_y(deg_to_rad(rotate_strength * CAM_ROTATION_SPEED * delta))


func on_collected_star() -> void:
	star_count += 1
	xsm.change_state("AwaitingCollectingStar")


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"anims_nsmb/coin_comp":
			xsm.change_state("None")
		"anims_nsmb/hipsr":
			xsm.change_state("Groundpounding")
		"anims_nsmb/big_hip_ed":
			x_locked = false
			y_locked = false
