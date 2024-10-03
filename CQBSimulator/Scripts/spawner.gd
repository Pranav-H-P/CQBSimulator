extends Node3D


var xExtents = 0
var zExtents = 0
var enemyData=[]

var spawnedList=[]

var alive=99999

const enemy = preload("res://Nodes/Enemy.tscn")

func returnFitnessValue(val,enemyId):
	pass

func activate():
	var spawnX=global_position.x
	var spawnZ=global_position.z
	var count=0
	if len(enemyData)==0:
		queue_free()
		
	for i in enemyData:
		var enem = enemy.instantiate()
		spawnedList.append(enem)
		add_child(enem)
		
		enem.enemySetup(i)
		
		
		if GLOBALS.currRound==1:
			enem.global_position.y=0.25;
			enem.global_position.x=GLOBALS.RNG.randi_range(spawnX,spawnX+xExtents)
			enem.global_position.z=GLOBALS.RNG.randi_range(spawnZ,spawnZ+zExtents)
			enem.enemyId=count
		else:
			pass#replace with neat round
		count+=1

func roundEnd():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alive==0:
		roundEnd()
		#add saving feature
		set_process(false)
