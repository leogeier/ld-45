extends Node2D


export(bool) var closed = true setget set_closed, get_closed

onready var sprite = $AnimatedSprite
onready var staticBody = $StaticBody2D
onready var collisionShape = $StaticBody2D/CollisionShape2D


func _ready():
	set_closed(closed)

func set_closed(value: bool) -> void:
	closed = value
	if sprite == null or collisionShape == null:
		return
	
	if closed:
		sprite.play("close")
		staticBody.set_collision_layer_bit(0, true)
		staticBody.set_collision_mask_bit(0, true)
	else:
		sprite.play("close", true)
		staticBody.set_collision_layer_bit(0, false)
		staticBody.set_collision_mask_bit(0, false)

func get_closed() -> bool:
	return closed