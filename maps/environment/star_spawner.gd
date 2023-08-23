extends Node

var stars: Array[Star]


func _ready() -> void:
	for child in get_children():
		assert(child is Star, "All children of a Star Spawner must be Star objects!")
		stars.append(child)
		child.collected.connect(_on_star_collected)
	
	_on_star_collected(null)


func _on_star_collected(which: Star) -> void:
	stars.pick_random().appear()
