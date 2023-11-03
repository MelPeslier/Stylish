extends CanvasLayer

@export var animator: AnimationPlayer
@export var particles_spaw: Marker2D

@onready var twirl_particles = preload("res://autoloads/scene_transition/twirl_particles.tscn")


func change_scene(target_path: String) -> void:
	animator.play("APPEAR")
	
	await animator.animation_finished
	
	get_tree().change_scene_to_file(target_path)
	animator.play("DISSIPATE")


func spawn_particles() -> void:
	particles_spaw.add_child(twirl_particles.instantiate())


func delete_particles() -> void:
	if particles_spaw.get_child_count() == 0:
		return
	
	for i in particles_spaw.get_children():
		i.queue_free()
