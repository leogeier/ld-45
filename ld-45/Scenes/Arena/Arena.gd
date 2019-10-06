extends Node2D

# INSTRUCTIONS: Press 0 to save the current config

const CONFIG_FOLDER = "res://Scenes/Arena/arenaConfigs/"

export(bool) var enable_config_saving = false
export(String) var init_config_file = ""

onready var doors = $Doors
var already_saved_config = false


func _ready():
	if init_config_file != "":
		load_arena_config(init_config_file)

# warning-ignore:unused_argument
func _process(delta):
	var input = Input.is_key_pressed(KEY_0)
	if enable_config_saving and (not already_saved_config) and input:
		save_arena_config()
		already_saved_config = true
		

func save_arena_config():
	var arena_config = get_arena_config()
	write_config_to_file(arena_config)

func get_arena_config() -> Dictionary:
	var config = {
		# all closed doors are saved to this array
		"doors": [],
		"spawners": []
	}
	
	for door in doors.get_children():
		if door.get_closed():
			config["doors"].append(door.get_name())
	
	return config

func write_config_to_file(config: Dictionary) -> void:
	var config_json = JSON.print(config)
	var file_name = "config-" + String(OS.get_unix_time()) + ".json"
	var file_path = CONFIG_FOLDER + file_name
	var file = File.new()
	
	print("Saving arena config as " + file_name + "...")
	
	file.open(file_path, File.WRITE)
	file.store_line(config_json)
	file.close()

func load_arena_config(file_name: String) -> void:
	var file = File.new()
	var file_path = CONFIG_FOLDER + file_name
	if not file.file_exists(file_path):
		print("Arena config file does not exist: " + file_path)
		return
	
	file.open(file_path, File.READ)
	var config = JSON.parse(file.get_line()).result
	
	for door in doors.get_children():
		door.set_closed(false)
		
	for door in config["doors"]:
		doors.find_node(door).set_closed(true)