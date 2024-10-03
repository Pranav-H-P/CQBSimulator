extends Node3D


var xExtents = 0
var zExtents = 0
var enemyData=[]

var spawnedList=[]

const enemy = preload("res://Nodes/Enemy.tscn")

func activate():
	var spawnX=global_position.x
	var spawnZ=global_position.z
	
	for i in enemyData:
		var enem = enemy.instantiate()
		spawnedList.append(enem)
		add_child(enem)
		
		enem.enemySetup(i)
		
		#replace with neat round
		enem.global_position.y=0.25;
		enem.global_position.x=GLOBALS.RNG.randi_range(spawnX,spawnX+xExtents)
		enem.global_position.z=GLOBALS.RNG.randi_range(spawnZ,spawnZ+zExtents)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
