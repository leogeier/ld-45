extends Node2D


func start_sound():
	var path = "Start"
	get_node(path).set_volume_db(-12.0) 
	get_node(path).play(0.000001)


func new_key_sound():
	var random = String(randi()%7+1)
	var path = "NewKey/Key" + random
	get_node(path).set_volume_db(-12.0) 
	#print("Play sound: ", random)
	get_node(path).play(0.000001)
	

func game_over_sound():
	var random = String(randi()%2+1)
	var path = "GameOver/GameOver" + random
	get_node(path).set_volume_db(-12.0) 
	#print("Play sound: ", random)
	get_node(path).play(0.000001)
	

func mixup_sound():
	var random = String(randi()%5+1)
	var path = "Mixup/mixup" + random
	get_node(path).set_volume_db(-12.0) 
	#print("Play sound: ", random)
	get_node(path).play(0.000001)