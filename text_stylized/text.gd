#@tool
extends Control

@export var label: Label
@export var v_box: VBoxContainer

@export var display_time: float = 10
var _local_time: float = 0

var _text_info: Array[int]
var _sequenced_text: Array[String]
var _text_time: Array[float]
var _number_of_letter: int

var _run_line_number: int


func _ready() -> void:
	_reset()
	_update_text(label.text)


func _update_text(new_text: String) -> void:
	if new_text.length() == 0: 
		print("Text vide.")
		return
	
	_text_info = _update_text_info(new_text)
	
	_number_of_letter = _text_info.reduce(
		func _sum(accum: int, number: int) -> int:
			return accum + number
	)
	_text_time = _update_text_time(_text_info, _number_of_letter)
	
	_sequenced_text = _sequence_text(new_text)
	
	if v_box.get_child_count() > 0:
		var childs = v_box.get_children()
		for child in childs: child.queue_free()
	
	for i in _sequenced_text:
		var lab: Label = Label.new()
		lab.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		
		lab.text = i
		v_box.add_child(lab)
	
	_mat_update_number_of_lines()


func _process(delta: float) -> void:
	pass
#	_update_text(label.text)
#	visibility(delta)




func visibility(delta: float) -> void:
	_local_time += delta
	_local_time = fmod(_local_time, display_time)
	
	var percentage_visible = remap(_local_time, 0, display_time, 0, 1)
	# ***** Easy way *****
#	visible_ratio = percentage_visible
	
	# ***** HARD way *****
	var actual_char = int(_number_of_letter * percentage_visible)
	
	# Line number
	var this_line_number: int = 0
	var indice_char: int = 0
	for i in _text_info:
		indice_char += i
		if actual_char <= indice_char:
			break
		else:
			this_line_number += 1
	
	if this_line_number != _run_line_number:
		_run_line_number = this_line_number
		_mat_update_this_line_number()
	
	# Percentage visible this line
	var min_time: float = 0
	var max_time: float = 0
	for i in _text_time:
		max_time += i
		max_time = clampf(max_time, 0, 1)
		if percentage_visible <= max_time:
			break
		else:
			min_time = max_time
	
	var this_line_percentage = remap(percentage_visible, min_time, max_time, 0, 1)
	_mat_update_percentage_visible(this_line_percentage)


func _mat_update_number_of_lines() -> void:
	var mat = material as ShaderMaterial
#	mat.set_shader_parameter("number_of_lines", _text_info.size())


func _mat_update_this_line_number() -> void:
	var mat = material as ShaderMaterial
#	mat.set_shader_parameter("this_line_number", _run_line_number + 1)


func _mat_update_percentage_visible(percentage: float) -> void:
	var mat = material as ShaderMaterial
#	mat.set_shader_parameter("percentage_visible", percentage)


func _update_text_info(new_text: String) -> Array[int]:
	var tab: Array[int] = [0]
	var current_line: int = 0
	for i in new_text:
		if i == "\n" or i == " ":
			if i == "\n":
				current_line += 1
				tab.push_back(0)
		else :
			tab[current_line] += 1
	
	return tab


func _sequence_text(new_text: String) -> Array[String]:
	var all: Array[String] = [""]
	var line: String = ""
	for i in new_text:
		if i == "\n":
			all.push_back(line)
			line = ""
		else:
			line += i
	all.push_back(line)
	all.pop_front()
	return all


func _update_text_time(text_tab: Array[int], letters_number: int) -> Array[float]:
	var tab: Array[float]
	var line_number = 0
	for i in text_tab:
		tab.push_back(0)
		tab[line_number] = remap(text_tab[line_number], 0, letters_number, 0, 1)
		line_number += 1
	
	return tab


func _reset() -> void:
	_run_line_number = 0
