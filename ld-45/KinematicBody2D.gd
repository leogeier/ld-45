extends KinematicBody2D

# externs:
export (int) var movement_speed = 50
export (int) var movement_acceleration 		= 10
export (int) var jump_speed 		= 10
export (int) var gravity_max_speed 		= 50
export (float) var gravity_acceleration 		= 10

const UP = Vector2(0,-1)
var motion = Vector2()

signal PlayerConnectedKey

func _ready():
	#add_to_group("Player")
	updateKeys()
	
#Needs to be called whenever a new Key Enters the Game
func updateKeys():
	var Keys = get_tree().get_nodes_in_group("Keys")
	for i in Keys:
		print("Connected to Key")
		i.connect("CollectKey", self, "_on_CollectKey")

func _on_CollectKey():
	emit_signal("PlayerConnectedKey")
	print("Player Collected Key!")
	pass

#returns updated current motion
#can be used for all acceleration purposes
func accelerate_movement(var current_motion, var target_speed, var acceleration):
		
	if abs(current_motion) < abs(target_speed):
		current_motion += acceleration
	
	if abs(current_motion) > abs(target_speed):
		current_motion = target_speed
		
	return current_motion
	

#updates the motion vector
#direction = 1 : right movement
#direction = -1 : left movement
func simple_x_movement(var direction):
	if motion.x * direction <= 0:
		motion.x = 0
	
	motion.x = accelerate_movement(motion.x,movement_speed * direction, movement_acceleration * direction)
	
	
func gravity_calculation():
		

		motion.y += gravity_acceleration
	
		if motion.y >= gravity_max_speed:
			motion.y = gravity_max_speed
	
	


#updates the motion vector
func update_motion():
	gravity_calculation()
	if Input.is_action_pressed("ui_right"):
		simple_x_movement(1)		
	elif Input.is_action_pressed("ui_left"):
		simple_x_movement(-1)
	else:
		motion.x = 0	
	
	if is_on_floor():	
		#print("on floor")
		if Input.is_action_just_pressed("ui_up"):
			
			motion.y = -jump_speed
	else:
		#print("not on floor")
		pass
		
		
var level = 0		#Level for Spawners	
func get_level():
	return level
		


func _physics_process(delta):
	
	update_motion()
	motion = move_and_slide(motion,UP)
	pass
