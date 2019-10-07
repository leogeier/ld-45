extends Label


export(String) var keybind_name = "Unknown"

var key = null setget set_key


func set_key(new_key):
	key = new_key
	if key == null:
		hide()
	else:
		self.set_text(keybind_name + ": " + key + "           ")
		show()