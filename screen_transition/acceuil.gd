extends Control

@onready var button: Button = $Button

var game_path: String = "res://screen_transition/game.tscn"

func _on_button_button_up() -> void:
	SceneTransition.change_scene(game_path)
