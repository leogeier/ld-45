extends Node2D

# INSTRUCTIONS: Press 0 to save the current config

const CONFIG_FOLDER = "res://Scenes/Arena/arenaConfigs/"
const INTRO_FOLDER = "res://Scenes/Arena/introConfigs/"

export(bool) var enable_config_saving = false
export(String) var init_config_file = ""
export(int) var key_despawn_time = 10

onready var doors = $Doors
onready var spawners = $Spawners
var already_saved_config = false
var active_spawners = []
var arena_configs = []
var intro_configs = []
var collected_keys = 0
var lifes_left = 3
var alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]

var intro_stage = 1
	
			
		
func loose_life():
	lifes_left -= 1
	$GUI.update_life(lifes_left)
	if lifes_left <= 0:
		print("you loose, please close the game now :( dont play anymore ")  		
		get_tree().quit()
	
	print("oh no you lost a life you still have " + String(lifes_left) + "though")
	if (collected_keys + 3 - lifes_left) % 3 == 0:
		print("update")
		update_arena()
	


func update_arena(config = null):
	#create an arena and spawn the key
	if config == null:
		arena_configs.shuffle()
		config = arena_configs.front()
	apply_config(config)
	spawn_keys()

func get_random_key():
	if alphabet.empty():
		print("last key spawned")
		return null
	randomize()
	alphabet.shuffle()
	return alphabet.pop_front()
	

func spawn_keys():
	active_spawners.shuffle()
	var r = min(3, active_spawners.size())
	for i in range (r):
		var spawn_inst = active_spawners.pop_front()
		spawn_inst.set_timeout(key_despawn_time)
		var button = get_random_key()
		if button == null:			
			return		
		var key = spawn_inst.spawn()			
		key.set_letter(button)
		if alphabet.empty():
			key.set_to_last()
			


func _ready():
	
	#var player = null
	#var stream = load("res://Sounds/GameMaster/Gong.wav")
	#stream.set_loop(true)
	
	#player = AudioStreamPlayer.new()
	#add_child(player)
	#player.set_stream(stream)
	#player.set_volume_db(-12)
	#player.play()
	

	
	$KinematicBody2D.connect("movement_updated",$GUI,"_on_keyupdate")
	
	if enable_config_saving:
		for s in spawners.get_children():
			if s.active:
				s.spawn()
		for d in doors.get_children():
			pass
	
	var config_dir = Directory.new()
	if config_dir.open(CONFIG_FOLDER) != OK:
		print("Failed to open arena config folder: " + CONFIG_FOLDER)
		return
	
	config_dir.list_dir_begin(true, true)
	var file_name = config_dir.get_next()
	
	var start_config = null
	while file_name != "":
		var config = read_config_from_file(file_name)
		arena_configs.append(config)
		if file_name == init_config_file:
			start_config = config
		file_name = config_dir.get_next()
	#if not enable_config_saving:
	#	update_arena(start_config)
	
	intro_configs.append(read_config_from_file("intro-1.json", INTRO_FOLDER))
	intro_configs.append(read_config_from_file("intro-2.json", INTRO_FOLDER))
	intro_configs.append(read_config_from_file("intro-3.json", INTRO_FOLDER))
	update_arena(intro_configs[0])
	
	$KinematicBody2D.add_controls(get_random_key())
	$GUI.update_collected_keys()
	$Musi/Musi.play()



	

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
		# all active spawners are saved to this array
		"spawners": []
	}
	
	for door in doors.get_children():
		if door.get_closed():
			config["doors"].append(door.get_name())
	
	for spawner in spawners.get_children():
		if spawner.active:
			config["spawners"].append(spawner.get_name())
	
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

func read_config_from_file(file_name: String, folder: String = CONFIG_FOLDER):
	var file = File.new()
	var file_path = folder + file_name
	if not file.file_exists(file_path):
		print("Arena config file does not exist: " + file_path)
		return null
	
	file.open(file_path, File.READ)
	return JSON.parse(file.get_line()).result

func apply_config(config: Dictionary) -> void:
	for door in doors.get_children():
		if config["doors"].has(door.get_name()):
			door.closed = true
		else:
			door.closed = false
	
	active_spawners.clear()
	for spawner in config["spawners"]:
		active_spawners.append(spawners.find_node(spawner))

func _on_Jesus_collect_signal():
	collected_keys += 1
	$GUI.update_collected_keys()
	if intro_stage < 3:
		match intro_stage:
			1:
				update_arena(intro_configs[1])
				intro_stage = 2
			2:
				$Bar1.hide()
				update_arena(intro_configs[2])
				intro_stage = 3
	else:
		$Bar2.hide()
		$Bar3.hide()
		if (collected_keys + 3 - lifes_left) % 3 == 0:
			update_arena()
