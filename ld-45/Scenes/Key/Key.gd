extends Sprite

var Collected
export (String) var playerName = "KinematicBody2D"
signal CollectKey

func _ready():
	#add_to_group("Keys")
	set_visible(true)
	Collected = false;

#check for collision with Node called "Player"
func _physics_process(delta):
	if Collected == false:
		var bodies = $Area2D.get_overlapping_bodies()
		for b in bodies:
			if b.get_name() == playerName:
				collectBehaviour()

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