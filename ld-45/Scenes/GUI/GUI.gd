extends Control

onready var label_left = $Container/Keybinds/Left
onready var label_right = $Container/Keybinds/Right
onready var label_jump = $Container/Keybinds/Jump

func _ready():
	label_left.key = "a"
	label_jump.key = "h"