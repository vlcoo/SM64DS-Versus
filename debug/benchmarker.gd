extends Control

@onready var container_low = $ContainerResults/ContainerLow
@onready var container_medium = $ContainerResults/ContainerMedium
@onready var container_high = $ContainerResults/ContainerHigh
@onready var label_fps = $Panel/HBoxContainer/LabelFPS
@onready var label_runtime = $Panel/HBoxContainer/LabelRuntime
@onready var label_status = $Panel/HBoxContainer/LabelStatus
@onready var view: SubViewport = $SubViewportContainer/BenchmarkedWorld
@onready var timer = $Timer
@onready var timer_fp_ss = $TimerFPSs
@onready var timer_test = $TimerTest

const STARTING_HALL = preload("res://maps/starting_hall.tscn")
const CASTLE_GROUNDS = preload("res://maps/castle_grounds.tscn")
const SECRET_SLIDE = preload("res://maps/secret_slide.tscn")

var current_scene
var current_container


var current_stage = -1: 
	set(v):
		current_stage = v
		match v:
			0:
				view.scaling_3d_scale = 0.5
				view.msaa_3d = Viewport.MSAA_DISABLED
				current_container = container_low
			1:
				view.scaling_3d_scale = 1.0
				view.msaa_3d = Viewport.MSAA_DISABLED
				current_container = container_medium
			2:
				view.scaling_3d_scale = 1.0
				view.msaa_3d = Viewport.MSAA_4X
				current_container = container_high
				get_window().mode = Window.MODE_FULLSCREEN
				view.size = get_window().size
			_:
				pass
var current_test = -1:
	set(v):
		current_test = v
		match v:
			0:
				time_start_test = Time.get_ticks_msec()
				current_scene = STARTING_HALL.instantiate()
				view.add_child(current_scene)
				current_container.get_node("LabelTime1").text = str(Time.get_ticks_msec() - time_start_test) + "ms"
				timer.start()
			1:
				timer_fp_ss.start()
				timer_test.start()
			2:
				time_start_test = Time.get_ticks_msec()
				view.remove_child(current_scene)
				current_scene = CASTLE_GROUNDS.instantiate()
				current_scene.get_node("3D/DirLightMain").shadow_enabled = current_stage != 0
				current_scene.get_node("3D/VoxelGI").visible = current_stage != 0
				view.add_child(current_scene)
				current_container.get_node("LabelTime3").text = str(Time.get_ticks_msec() - time_start_test) + "ms"
				timer.start()
			3:
				current_scene.current_player.camera_follow = false
				timer_fp_ss.start()
				timer_test.start()
				path = current_scene.get_node("3D/Path3D/PathFollow3D")
			4:
				view.remove_child(current_scene)
				timer.start()
			_:
				pass

var time_start = 0
var time_start_test = 0
var fpss = []
var path


func _ready():
	get_window().always_on_top = true


func _on_timer_timeout():
	if current_stage < 0:
		current_stage = 0
	
	current_test += 1
	if current_test > 4:
		current_test = 0
		current_stage += 1
		if current_stage > 2:
			timer.stop()


func _process(delta):
	label_fps.text = str(Engine.get_frames_per_second()) + " FPS"
	label_runtime.text = str(Time.get_ticks_msec() / 1000) + "s - test " + str(current_test) + ", stage " + str(current_stage)
	
	if path:
		path.progress_ratio += 0.001


func _on_timer_fp_ss_timeout():
	fpss.append(Engine.get_frames_per_second())


func _on_timer_test_timeout():
	match current_test:
		1:
			timer_fp_ss.stop()
			var sum = 0
			for fps in fpss:
				sum += fps
			current_container.get_node("LabelTime2").text = str(sum/fpss.size()) + " FPS"
			fpss.clear()
			timer.start()
		3:
			timer_fp_ss.stop()
			var sum = 0
			for fps in fpss:
				sum += fps
			current_container.get_node("LabelTime4").text = str(sum/fpss.size()) + " FPS"
			fpss.clear()
			timer.start()
			path = null
