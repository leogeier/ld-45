extends Node2D

# INSTRUCTIONS: Press 0 to save the current config

export(bool) var enable_config_saving = false

onready var doors = $Doors
var already_saved_config = false


func _process(delta):
	var input = Input.is_key_pressed(KEY_0)
	if enable_config_saving and (not already_saved_config) and input:
		save_arena_config()
		already_saved_config = true
		

func save_arena_config():
	var arena_config = JSON.print(get_arena_config())
	var file_name = "config-" + String(OS.get_unix_time()) + ".json"
	var file_path = "res://Scenes/Arena/arenaConfigs/" + file_name
	var file = File.new()
	
	print("Saving arena config as " + file_name + "...")
	
	file.open(file_path, File.WRITE)
	file.store_line(arena_config)
	file.close()


func get_arena_config() -> Dictionary:
	var config = {
		# all closed doors are saved to this array
		"doors": [],
		"spawner": []
	}
	
	for door in doors.get_children():
		if door.get_closed():
			config["doors"].append(door.get_name())
	
	return config
	
	