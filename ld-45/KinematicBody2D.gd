extends KinematicBody2D
# externs:
export (int) var movement_speed = 50
export (int) var movement_acceleration 		= 10
export (int) var jump_speed 		= 10
export (int) var gravity_max_speed 		= 50
export (float) var gravity_acceleration 		= 10
export (float) var jumpaccelerant 		= 10
export (float) var	gracetime			= 0.1
export (int) var x_width 		= 320
export (int) var	y_height			= 200
export (bool) var	wasd_controls			= false

const UP = Vector2(0,-1)
var motion = Vector2()
var PlayerInput
var jumptimer
var jumppressed	:bool	#bool
var gracetimer_calculator
var alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
var movement_actions = ["left","jump","right",]
var collected_actions = 0
signal collect_signal
signal movement_updated


	
#Needs to be called whenever a new Key Enters the Game
func updateKeys():
	var Keys = get_tree().get_nodes_in_group("Keys")
	for i in Keys:
		i.connect("CollectKey", self, "_on_CollectKey")


func _on_CollectKey(key):
	collect_sound()
	emit_signal("collect_signal")	
	if wasd_controls:
		return
	if key == null:
		print("you win")
		return
		
	emit_signal("movement_updated",movement_actions[collected_actions % 3],key)
	PlayerInput.set_action_key(movement_actions[collected_actions % 3],key)
	print(movement_actions[collected_actions % 3] + " is now " + key)
	collected_actions += 1
	

#returns updated current motion
#can be used for all acceleration purposes
#description:
#adds acceleration to current_motion until a max of target_speed 
func accelerate_movement(var current_motion, var target_speed, var acceleration):
		
	if abs(current_motion) < abs(target_speed):
		current_motion += acceleration
	
	if abs(current_motion) > abs(target_speed):
		current_motion = target_speed
		
	return current_motion
	

#updates the motion vector
#direction = 1 : right movement
#direction = -1 : left movement
func simple_x_movement( direction):
	get_node("AnimatedSprite").play()
	
	if motion.x * direction <= 0:
		motion.x = 0
	
	if direction > 0:
		get_node("AnimatedSprite").set_flip_h( true )
	else:
		get_node("AnimatedSprite").set_flip_h( false )
	
	motion.x = accelerate_movement(motion.x,movement_speed * direction, movement_acceleration * direction)
	
	
func gravity_calculation():
		motion.y += gravity_acceleration
	
		if motion.y >= gravity_max_speed:
			motion.y = gravity_max_speed
	
	
func calculate_jump_motion(delta):
	if gracetimer_calculator > 0 && jumppressed == false:	
		jump_sound()
		jumptimer = jumpaccelerant
		motion.y = -jump_speed
	elif jumptimer > 0:
		jumptimer -= delta
		motion.y = -jump_speed
	
	
	
func jump_movement(delta):
	calculate_grace_timer(delta)
	#set the flag that the jumpbotton has been pressed
	#calculate the new motion vector based on the jumptimer and floor
	if PlayerInput.is_action_pressed("jump"):		
		calculate_jump_motion(delta)
		jumppressed = true
	#set the flag that the jumpbotton has been released	
	#set jumptimer to 0 because the button has been released (stop accelerating)
	else:
		jumppressed = false
		jumptimer = 0
	
func calculate_grace_timer(delta):
	if is_on_floor():
		gracetimer_calculator = gracetime
	else:
		gracetimer_calculator -= delta
		
		
var level = 0		#Level for Spawners	
func get_level():
	return level
		

#updates the motion vector
func update_motion(delta):
	#add x axis movement	
	if PlayerInput.is_action_pressed("right"):
		simple_x_movement(1)
		
	elif PlayerInput.is_action_pressed("left"):
		simple_x_movement(-1)

	else:
		motion.x = 0
		get_node("AnimatedSprite").stop()	
		
	# add gravity to y axis
	gravity_calculation()
	#add jump to y axis
	jump_movement(delta)

func update_looping_position():
	if self.position.x <= 0:		
		self.position.x = x_width
	elif self.position.x >=x_width:
		self.position.x = 0
		pass



func _physics_process(delta):
	update_looping_position()
	#update motion vector
	update_motion(delta)
	#moving and sliding around
	motion = move_and_slide(motion,UP)
	
func jump_sound():
	var random = String(randi()%4+1)
	var path = "JumpSounds/jump" + random
	get_node(path).set_volume_db(-12.0) 
	#print("Play sound: ", random)
	get_node(path).play(0.000001)
	
func death_sound():
	var random = String(randi()%2+1)
	var path = "DeathSounds/death" + random
	get_node(path).set_volume_db(-12.0) 
	#print("Play sound: ", random)
	get_node(path).play(0.000001)

func collect_sound():
	var random = String(randi()%9+1)
	var path = "CollectSounds/key" + random
	get_node(path).set_volume_db(-12.0) 
	#print("Play sound: ", random)
	get_node(path).play(0.000001)
	

func late_sound():
	var random = String(randi()%6+1)
	var path = "LateSounds/late" + random
	get_node(path).set_volume_db(-12.0) 
	#print("Play sound: ", random)
	get_node(path).play(0.000001)
	
func _ready():
	PlayerInput = preload("res://Scenes/Player/PlayerInput.gd").new()
	PlayerInput._init()
	jumptimer = 0
	jumppressed = false
	gracetimer_calculator = gracetime
	#get_node("AudioStreamPlayer").set_volume_db(-12)
	#get_node("AudioStreamPlayer").set_autoplay(false)
	randomize()
	alphabet.shuffle()
	
	
func add_controls(key):
	if wasd_controls:
		PlayerInput.set_action_key("jump","w")
		PlayerInput.set_action_key("left","a")
		PlayerInput.set_action_key("right","d")
	else:
		PlayerInput.set_action_key("right",key)
		emit_signal("movement_updated","right",key)
		print("left" + " is now " + key)
	
