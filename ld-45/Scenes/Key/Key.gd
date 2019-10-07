extends Node2D

var Collected
#export (String) var playerName = "KinematicBody2D"
export (bool) var hasGravity = false
export (int) var GravitySpeed = 5
export (int) var keyTimeout = 3
var TimeLeft
signal CollectKey
var Player
var letter: String setget set_letter
onready var sprite = $KinematicBody2D/Sprite
const ALPHABET = "abcdefghijklmnopqrstuvwxyz"

func set_Timeout(seconds):
	keyTimeout = seconds

func get_Timeout():
	return keyTimeout

func _ready():
	#add_to_group("Keys")
	var p = get_tree().get_nodes_in_group("Player")
	if p.size() > 0:
		Player = p[0]
		Player.updateKeys()
	set_visible(true)
	TimeLeft = keyTimeout
	Collected = false;

#check for collision with Node called "Player"
func _physics_process(delta):
	if hasGravity:
		#TODO: Doesn't move because not known
		var movementVector = Vector2(0,GravitySpeed)
		$KinematicBody2D.move_and_slide(movementVector)
		#print("Moved down!")
	if TimeLeft <= 0:
		delete_self()
	TimeLeft -=delta

func set_letter(value: String) -> void:
	letter = value
	if letter.length() == 1 and ALPHABET.find(letter) != -1:
		var path = "res://Scenes/Key/assets/key_" + letter + ".png"
		sprite.set_texture(load(path))

func delete_self():
	print("I wasn't collected!")
	set_visible(false) 
	get_parent().remove_child(self)
	queue_free()
	#add Sound for failure

func collectBehaviour():
	emit_signal("CollectKey")
	#print("I was collected")
	set_visible(false) 
	Collected = true
	collectSound()
	get_parent().remove_child(self)
	queue_free()

#Returns the current state of the Gem
func is_collected():
	return Collected
	
func collectSound():
	#var random = String(randi()%6+1)
	#var path = "../GemSounds/GemSound" + random
	#get_node(path).set_volume_db(-12.0) 
	#print("Play sound: ", random)
	#get_node(path).play(0.000001)
	pass

func _on_Area2D_body_entered(body):
	var bodies = $KinematicBody2D/Area2D.get_overlapping_bodies()
	for b in bodies:
		if b == Player:
			collectBehaviour()
