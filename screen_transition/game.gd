extends Node3D

@onready var menu: CanvasLayer = $Menu

var acceuil_path: String = "res://screen_transition/acceuil.tscn"

func _ready() -> void:
	menu.visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		menu.visible = not menu.visible


func _on_button_button_up() -> void:
	SceneTransition.change_scene(acceuil_path)
