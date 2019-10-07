extends Control

onready var label_left = $Container/VBoxContainer/Keybinds/Left
onready var label_right = $Container/VBoxContainer/Keybinds/Right
onready var label_jump = $Container/VBoxContainer/Keybinds/Jump

onready var labels = {
	"left": label_left,
	"right": label_right,
	"jump": label_jump
}

func update_keybind(label, key: String) -> void:
	labels[label].set_key(key)