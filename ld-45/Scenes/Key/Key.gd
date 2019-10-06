extends Node2D

var Collected
#export (String) var playerName = "KinematicBody2D"
export (bool) var hasGravity = false
export (int) var GravitySpeed = 5
export (int) var keyTimeout = 3
var TimeLeft
signal CollectKey
var Player

func set_Timeout(seconds):
	keyTimeout = seconds

func get_Timeout():
	return keyTimeout


func _ready():
	Player = get_tree().get_nodes_in_group("Player")[0]
	Player.updateKeys()
	set_visible(true)
	TimeLeft = keyTimeout
	Collected = false;

#check for collision with Node called "Player"
func _physics_process(delta):
	if hasGravity:
		var movementVector = Vector2(0,GravitySpeed)
		$KinematicBody2D.move_and_slide(movementVector)
		
	if TimeLeft <= 0:
		delete_self()
		
	TimeLeft -=delta

func delete_self():
	Player.late_sound()
	set_visible(false) 
	get_parent().remove_child(self)
	queue_free()

func collectBehaviour():
	emit_signal("CollectKey")
	set_visible(false) 
	get_parent().remove_child(self)
	queue_free()

#Returns the current state of the Gem
func is_collected():
	return Collected

func _on_Area2D_body_entered(body):
	var bodies = $KinematicBody2D/Area2D.get_overlapping_bodies()
	for b in bodies:
		if b == Player:
			collectBehaviour()
