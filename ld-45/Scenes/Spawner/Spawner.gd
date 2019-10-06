extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var Level = 0
export(bool) var active = true
var Key = preload("res://Scenes/Key/Key.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_visible(false)
	pass # Replace with function body.

func getLevel():
	return Level
	


func spawn():
	var newKey = Key.instance()
	#self.add_child(newKey)
	#print("Spawn")
	get_tree().get_nodes_in_group("Map")[0].add_child(newKey)
	newKey.position = position
	#newKey.position = 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
