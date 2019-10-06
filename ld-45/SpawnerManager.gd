extends Node2D

var SpawnerNumbers

var Player
var Spawners = []		#Dictionary of all Spawners
var spawns = 0
export (int) var cooldownTime = 2
var passedSpawnTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Get the Player:
	Player = get_tree().get_nodes_in_group("Player")[0]
	Player.connect("PlayerConnectedKey", self, "_on_PlayerConnectedKey")
	#print("SpawnerManager Connected to Player!")
	
	#Get the Spawners:
	Spawners = get_tree().get_nodes_in_group("Spawner")
	
	

func Spawn(Level):
	var PossibleSpawners = []
	#finds all possible Spawners for that Level (to make collection Possible)
	for i in Spawners:
		if i.getLevel() <= Level:
			PossibleSpawners.append(i)

	#print("Possible Spawners: ", PossibleSpawners)
	PossibleSpawners.shuffle()
	PossibleSpawners[0].spawn()
	spawns +=1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	passedSpawnTime +=delta
	if passedSpawnTime >= cooldownTime:
		passedSpawnTime = 0
		Spawn(Player.get_level())
		#print("Manager Spawned")
		
func _on_PlayerConnectedKey():
	pass