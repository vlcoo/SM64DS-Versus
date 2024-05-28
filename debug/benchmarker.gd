extends Control

@onready var container_low = $ContainerResults/ContainerLow
@onready var container_medium = $ContainerResults/ContainerMedium
@onready var container_high = $ContainerResults/ContainerHigh
@onready var label_fps = $Panel/HBoxContainer/LabelFPS
@onready var label_runtime = $Panel/HBoxContainer/LabelRuntime
@onready var label_status = $Panel/HBoxContainer/LabelStatus
@onready var world = $BenchmarkedWorld
@onready var timer = $Timer
@onready var timer_fp_ss = $TimerFPSs
@onready var timer_test = $TimerTest

const STARTING_HALL = preload("res://maps/starting_hall.tscn")
const CASTLE_GROUNDS = preload("res://maps/castle_grounds.tscn")
const SECRET_SLIDE = preload("res://maps/secret_slide.tscn")

var current_scene
var current_container
var rid


var current_stage = -1: 
	set(v):
		current_stage = v
		match v:
			0:
				RenderingServer.viewport_set_scaling_3d_scale(rid, 0.5)
				RenderingServer.viewport_set_msaa_3d(rid, RenderingServer.VIEWPORT_MSAA_DISABLED)
				current_container = container_low
			1:
				RenderingServer.viewport_set_scaling_3d_scale(rid, 1.0)
				RenderingServer.viewport_set_msaa_3d(rid, RenderingServer.VIEWPORT_MSAA_DISABLED)
				current_container = container_medium
			2:
				RenderingServer.viewport_set_scaling_3d_scale(rid, 1.0)
				RenderingServer.viewport_set_msaa_3d(rid, RenderingServer.VIEWPORT_MSAA_4X)
				current_container = container_high
				get_window().mode = Window.MODE_FULLSCREEN
			_:
				timer.stop()
				get_window().mode = Window.MODE_WINDOWED
				get_window().size = Vector2(1200, 700)
				world.remove_child(current_scene)
				label_status.visible = true
				process_mode = Node.PROCESS_MODE_DISABLED
var current_test = -1:
	set(v):
		current_test = v
		match v:
			0:
				current_container.get_node("LabelTime1").text = "..."
				time_start_test = Time.get_unix_time_from_system()
				print(time_start_test)
				current_scene = STARTING_HALL.instantiate()
				current_scene.get_node("3D/DirLightMain").shadow_enabled = current_stage != 0
				current_scene.get_node("3D/VoxelGI").visible = current_stage != 0
				world.add_child(current_scene)
				current_container.get_node("LabelTime1").text = str(Time.get_unix_time_from_system() - time_start_test) + "s"
				timer.start()
			1:
				current_container.get_node("LabelTime2").text = "..."
				timer_fp_ss.start()
				timer_test.start()
			2:
				current_container.get_node("LabelTime3").text = "..."
				time_start_test = Time.get_unix_time_from_system()
				world.remove_child(current_scene)
				current_scene = CASTLE_GROUNDS.instantiate()
				current_scene.get_node("3D/DirLightMain").shadow_enabled = current_stage != 0
				current_scene.get_node("3D/VoxelGI").visible = current_stage != 0
				world.add_child(current_scene)
				current_container.get_node("LabelTime3").text = str(Time.get_unix_time_from_system() - time_start_test) + "s"
				timer.start()
			3:
				current_container.get_node("LabelTime4").text = "..."
				current_scene.current_player.process_mode = PROCESS_MODE_DISABLED
				current_scene.current_player.queue_free()
				timer_fp_ss.start()
				timer_test.start()
				path = current_scene.get_node("3D/Path3D/PathFollow3D")
			4:
				current_container.get_node("LabelTime5").text = "..."
				timer_fp_ss.start()
				timer_test.start()
				for i in range(3):
					var p = current_scene.spawn_player()
					p.cam.current = false
					if randf() < 0.5: p.on_collected_star()
				for i in range(10):
					var s = await current_scene.get_node("3D/Stars").stars.pick_random().appear()
					if randf() < 0.2 and s: s._on_area_3d_body_entered(current_scene.spawn_player())
			_:
				pass

var time_start = 0
var time_start_test = 0
var fpss = []
var path


func _ready():
	get_window().always_on_top = true
	rid = get_viewport().get_viewport_rid()


func _on_timer_timeout():
	if current_stage < 0:
		current_stage = 0
	
	current_test += 1
	if current_test > 4:
		current_stage += 1
		current_test = 0


func _process(delta):
	label_fps.text = str(Engine.get_frames_per_second()) + " FPS"
	label_runtime.text = str(Time.get_ticks_msec() / 1000) + "s - test " + str(current_test+1) + ", stage " + str(current_stage+1)
	
	if path:
		path.progress_ratio += 0.1 * delta


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
		4: 
			timer_fp_ss.stop()
			var sum = 0
			for fps in fpss:
				sum += fps
			current_container.get_node("LabelTime5").text = str(sum/fpss.size()) + " FPS"
			fpss.clear()
			path = null
			world.remove_child(current_scene)
			timer.start()
