extends KinematicBody2D

# externs:
export (int) var movement_speed = 50
export (int) var movement_acceleration 		= 10
export (int) var gravity 		= 50


var motion = Vector2()

#return the updated motion vector
#direction = 1 : right movement
#direction = -1 : left movement
func simple_x_movement(var motion,var direction):
	#if movement has not reached target speed accelerate:
	if motion.x * direction <= 0:
		motion.x = 0
	
	if abs(motion.x) < movement_speed:
		motion.x = motion.x + movement_acceleration * direction
	#if motion vector has surpassed movement speed reset to max speed
	if abs(motion.x) >= movement_speed:
		motion.x = movement_speed * direction	
	
	
	return motion.x

#returns the updated vector
func update_motion(var vector):
	if Input.is_action_pressed("ui_right"):
		vector.x =  simple_x_movement(motion,1)
	elif Input.is_action_pressed("ui_left"):
		vector.x =  simple_x_movement(motion,-1)
	else:
		vector.x = 0	
	vector.y = gravity
	return vector

func _physics_process(delta):
	motion = update_motion(motion)
	move_and_slide(motion)
	pass
