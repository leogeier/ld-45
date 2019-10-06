tool
extends Node2D


# Marking this checkbox saves the config to file
export(bool) var save_arena_config = false setget set_save_arena_config

func set_save_arena_config(value):
	save_arena_config = value
	if not save_arena_config:
		return
	
	var arena_config = JSON.print(get_arena_config())
	var file_name = "config-" + String(OS.get_unix_time()) + ".json"
	var file_path = "res://Scenes/Arena/arenaConfigs/" + file_name
	var file = File.new()
	
	print("Saving arena config as " + file_name + "...")
	
	file.open(file_path, File.WRITE)
	file.store_line(arena_config)
	file.close()


func get_arena_config() -> Dictionary:
	return {"key": "value"}