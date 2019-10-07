extends Control

onready var label_left = $Container/VBoxContainer/Keybinds/Left
onready var label_right = $Container/VBoxContainer/Keybinds/Right
onready var label_jump = $Container/VBoxContainer/Keybinds/Jump
onready var life_display = $Container/VBoxContainer/HBoxContainer/LifeDisplay
onready var collection_count = $Container/VBoxContainer/HBoxContainer/CollectionCount

onready var labels = {
	"left": label_left,
	"right": label_right,
	"jump": label_jump
}

func _on_keyupdate(action,key):
	update_keybind(action,key)
	


func update_keybind(label : String, key: String) -> void:
	labels[label].set_key(key)
	
func update_life(new_life):
	life_display.set_life(new_life)
	
func update_collected_keys():
	collection_count.increment()
	