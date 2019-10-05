extends KinematicBody2D
# externs:
export (int) var movement_speed = 50
export (int) var movement_acceleration 		= 10
export (int) var jump_speed 		= 10
export (int) var gravity_max_speed 		= 50
export (float) var gravity_acceleration 		= 10

const UP = Vector2(0,-1)
var motion = Vector2()
var PlayerInput

	

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
	if motion.x * direction <= 0:
		motion.x = 0
	
	motion.x = accelerate_movement(motion.x,movement_speed * direction, movement_acceleration * direction)
	print(motion.x)
	
	
func gravity_calculation():
		motion.y += gravity_acceleration
	
		if motion.y >= gravity_max_speed:
			motion.y = gravity_max_speed
	
	


#updates the motion vector
func update_motion():
	#add x axis movement
	#if Input.is_action_pressed("ui_right"):
	if PlayerInput.is_action_pressed("right"):
		print("move right")
		simple_x_movement(1)
	#elif Input.is_action_pressed("ui_left"):
	elif PlayerInput.is_action_pressed("left"):
		simple_x_movement(-1)
	else:
		motion.x = 0	
		
	# add gravity to y axis
	gravity_calculation()
	#add jump to y axis
	if PlayerInput.is_action_pressed("up") && is_on_floor():
		motion.y = -jump_speed

func _ready():
	PlayerInput = preload("res://Scenes/Player/PlayerInput.gd").new()
	PlayerInput._init()
	PlayerInput.set_action_key("right","d")
	PlayerInput.set_action_key("left","a")
	PlayerInput.set_action_key("up","w")


func _physics_process(delta):
	#update motion vector
	update_motion()
	#moving and sliding around
	motion = move_and_slide(motion,UP)
	pass
