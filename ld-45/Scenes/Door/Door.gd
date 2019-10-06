extends Node2D


export(bool) var closed = true setget set_closed, get_closed

onready var sprite = $Sprite
onready var collisionShape = $StaticBody2D/CollisionShape2D


func _ready():
	set_closed(closed)

func set_closed(value: bool) -> void:
	closed = value
	if sprite == null or collisionShape == null:
		return
	
	if closed:
		sprite.show()
		collisionShape.disabled = false
	else:
		sprite.hide()
		collisionShape.disabled = true

func get_closed() -> bool:
	return closed