extends Control

onready var label_left = $Container/Keybinds/Left
onready var label_right = $Container/Keybinds/Right
onready var label_jump = $Container/Keybinds/Jump

onready var labels = {
	"left": $Container/Keybinds/Left,
	"right": $Container/Keybinds/Right,
	"jump": $Container/Keybinds/Jump
}

func update_keybind(label, key: String) -> void:
	labels[label].set_key(key)