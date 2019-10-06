extends Node2D

export (int) var SpawnerTimeout = 50
var Key = preload("res://Scenes/Key/Key.tscn")


func _ready():
	set_visible(false)

func set_timeout(seconds):
	SpawnerTimeout = seconds
	pass

func spawn():
	var newKey = Key.instance()
	get_tree().get_nodes_in_group("Map")[0].add_child(newKey)
	newKey.position = position
	newKey.set_Timeout(SpawnerTimeout)
	return newKey
