extends KinematicBody2D
# externs:
export (int) var movement_speed = 50
export (int) var movement_acceleration 		= 10
export (int) var jump_speed 		= 10
export (int) var gravity_max_speed 		= 50
export (float) var gravity_acceleration 		= 10
export (float) var jumpaccelerant 		= 10

const UP = Vector2(0,-1)
var motion = Vector2()
var PlayerInput
var jumptimer

	

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
	
	
func jump_movement(delta):
	if jumptimer <= 0 && !is_on_floor():
		return
	if is_on_floor():
		jumptimer = jumpaccelerant
	else:
		print(delta)
		jumptimer -= delta
	
	motion.y = -jump_speed
	
		
		

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
	if PlayerInput.is_action_pressed("up"):
		jump_movement(delta)
	else:
		jumptimer = 0




func _physics_process(delta):
	#update motion vector
	update_motion(delta)
	#moving and sliding around
	motion = move_and_slide(motion,UP)
	
	
	
func _ready():
	PlayerInput = preload("res://Scenes/Player/PlayerInput.gd").new()
	PlayerInput._init()
	PlayerInput.set_action_key("right","d")
	PlayerInput.set_action_key("left","a")
	PlayerInput.set_action_key("up","w")
	jumptimer = 0
