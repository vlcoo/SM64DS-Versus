@icon("res://debug/y_icon.png")
class_name Player
extends CharacterBody3D

enum FloorTypes {NOCODE, GROUND, GRASS, FLOWER, ICE, ROCK, SAND, SNOW, WATER, WIRE, WOOD}

var GRAVITY: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export_group("Movement physics")
## Horizontal speed.
@export var RUN_SPEED: float
## Horizontal deceleration while being pushed by a force such as a longjump or kick.
@export var SOFT_X_DAMPING: float
## Horizontal deceleration rate.
@export var DECEL_STRENGTH: float 
## Run speed multiplier of a crawl.
@export_range(0, 1, 0.1) var CRAWL_MULTIPLIER: float
## Upwards velocity of a jump.
@export var JUMP_STRENGTH: float
## Jump strength multiplier of the double jump.
@export var JUMP2_MULTIPLIER: float
## Jump strength multiplier of the triple jump.
@export var JUMP3_MULTIPLIER: float
## Minimum distance to jump before it can be cut short by releasing the jump button.
@export var JUMP_INTERRUPT_THRESHOLD: float
## Run speed velocity multiplier of a longjump.
@export var LONGJUMP_X_MULTIPLIER: float
## Softening of horizontal inputs while longjumping.
@export var LONGJUMP_X_DAMPING: float
## Upwards velocity of a longjump.
@export var LONGJUMP_Y_STRENGTH: float
## Downwards velocity of a groundpound.
@export var GROUNDPOUND_STRENGTH: float
## Upwards velocity while fluttering.
@export var FLUTTER_STRENGTH: float
## Minimum falling velocity the player must have to be able to start a flutter.
@export var FLUTTER_THRESHOLD: float
@export_group("Timers")
## Time in seconds the player has to perform a double jump after touching the floor.
@export var JUMP2_TIME: float
## Time in seconds the player needs to be falling for to receive fall damage.
@export var LONG_FALL_TIME: float
## Time in seconds the player will wait in mid-air before dropping on a groundpound.
@export var GROUNDPOUND_IMPACT_TIME: float
## Time in seconds a flutter can last for at most.
@export var FLUTTER_TIME: float
@export_group("Camera settings")
## Speed of the camera rotation with the shoulder buttons.
@export var CAM_ROTATION_SPEED: float = 1.0
## If enabled, this player will be controllable and the camera will follow them.
@export var camera_follow: bool = true

var SFXs: Dictionary = {
	"impact_groundpound": preload("res://audio/sfx/environment/impact_groundpound.ogg"),
	"roll": preload("res://audio/sfx/environment/roll.ogg"),
	"star_touched": preload("res://audio/sfx/jingles/star_touched.ogg")
}

@onready var animation: AnimationTree = $AnimationTree
@onready var model: Skeleton3D = $Model
@onready var xsm: StateRegions = $XSM
@onready var sfx: AudioStreamPlayer3D = $SFX
@onready var sfx_steps: AudioStreamPlayer3D = $SFXSteps
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var mat_head: ShaderMaterial = $Model/Head.mesh.surface_get_material(0)
@onready var mat_body: ShaderMaterial = $Model/Head.mesh.surface_get_material(1)

@onready var cam: Camera3D = $SpringArmPivot/SpringArm3D/Camera3D
@onready var cam_pivot: Node3D = $SpringArmPivot
@onready var cam_arm: SpringArm3D = $SpringArmPivot/SpringArm3D
@onready var cam_sfx: AudioStreamPlayer = $SpringArmPivot/CamShiftSFX
var _is_cam_zoomed: bool = false

var x_locked: bool = false
var y_locked: bool = false
var current_floor: FloorTypes = FloorTypes.NOCODE

var star_count: int = 0

signal cam_shifted(direction: int)
signal cam_zoomed(zoom_in: bool)
signal got_star(new_count: int)


func _ready() -> void:
	for file in DirAccess.open("res://audio/sfx/voice/").get_files():
		if ".import" in file or not "y_" in file: continue
		SFXs[file.replace(".ogg", "").replace("y_", "")] = load("res://audio/sfx/voice/" + file)
	for file in DirAccess.open("res://audio/sfx/environment/impact_floors/").get_files():
		if ".import" in file: continue
		SFXs[file.replace(".ogg", "")] = load("res://audio/sfx/environment/impact_floors/" + file)
	
	$SpringArmPivot/SpringArm3D/Camera3D.current = camera_follow
	$Nametag.visible = camera_follow
	xsm.disabled = not camera_follow
	
	var h := randf()
	mat_body.set_shader_parameter("new_color", Color.from_hsv(h, 1.0, 0.7))
	mat_head.set_shader_parameter("new_color", Color.from_hsv(h, 1.0, 0.7))
	
	if camera_follow: $Nametag/Label3D.text = Utils.player_nickname


func start_picture_anim() -> void:
	xsm.disabled = true
	animation.active = false
	$AnimationPlayer.play("anims_nsmb/jump")
	play_sfx("couple")


func play_sfx(which: String, is_not_voice: bool = false) -> void:
	if is_not_voice:
		var step_sfx: String = which if not which in ["land", "jump", "walk"] else which + "_" + FloorTypes.keys()[current_floor].to_lower()
		assert(step_sfx in SFXs.keys(), "Tried to play SFX that doesn't exist.")
		sfx_steps.stream = SFXs[step_sfx]
		sfx_steps.play()
	else:
		assert(which in SFXs.keys(), "Tried to play SFX that doesn't exist.")
		sfx.stream = SFXs[which]
		sfx.play()


func _process(delta: float) -> void:
	if not camera_follow: 
		cam.current = false
		return
	
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
