extends Reference

class_name PlayerInput


const ALPHABET = "abcdefghijklmnopqrstuvwxyz"

var action_map = {}

# maps letters to scancodes
var scancodes = {}


func _init():
	for i in range(26):
		var letter = ALPHABET[i]
		# scancodes for letters start at 65
		scancodes[letter] = i + 65

func set_action_key(action, key):
	action_map[action] = key

func is_action_pressed(action):
	if action_map.has(action):
		var key = action_map[action]
		return Input.is_key_pressed(scancodes[key])
	return false
	