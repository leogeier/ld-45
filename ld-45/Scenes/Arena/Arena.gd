tool
extends Node2D


# Marking this checkbox saves the config to file
export(bool) var save_arena_config = false setget set_save_arena_config

func set_save_arena_config(value):
	save_arena_config = value
	if not save_arena_config:
		return
	
	print("saving")