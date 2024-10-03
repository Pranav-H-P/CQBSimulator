extends Node3D

@onready var loadingBlock=$LevelUI/UITab/ColorRect
@onready var uiAnim=$LevelUI/UITab/AnimationPlayer
@onready var timesShot=$LevelUI/UITab/TimesShot
@onready var player=$Player

var door=preload("res://Nodes/Door.tscn")
var genericCube=preload("res://Nodes/GenericCube.tscn")
var spawner=preload("res://Nodes/Spawner.tscn")

var wallHeight=7
var coverHeight=1.5
var levelData
var mapData
var shotCount=0

func playerShot():
	shotCount+=1
	timesShot.text="Times Shot: "+str(shotCount)

func getEnemyTypes(enemyData):
	var enemies=[]
	var totalEnemyCount=0
	for i in enemyData:
		totalEnemyCount+=i[1]
	
	var enemyCount=GLOBALS.RNG.randi_range(0,totalEnemyCount)
	
	for i in range(enemyCount):
		var pick=GLOBALS.RNG.randi_range(0,len(enemyData)-1)
		enemies.append(enemyData[pick][0])
		enemyData[pick][1]-=1
		if enemyData[pick][1]<=0:
			enemyData.remove_at(pick)
		
	return enemies
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
	loadingBlock.visible=true
	
	levelData=GLOBALS.getCurrLevelData()
	
	mapData=levelData["MapData"]
	
	
	
	
	player.weaponData=levelData["PlayerData"]
	
	var outerWall1 = genericCube.instantiate()
	var outerWall2 = genericCube.instantiate()
	var outerWall3 = genericCube.instantiate()
	var outerWall4 = genericCube.instantiate()
	#var ceiling = genericCube.instantiate()
	
	
	add_child(outerWall1)
	add_child(outerWall2)
	add_child(outerWall3)
	add_child(outerWall4)
	#add_child(ceiling)
	
	var foundationPos=mapData["foundation"]["startCoords"]
	var foundationSize=mapData["foundation"]["size"]
		
	var outerWallPositions=[
		[foundationPos[0],foundationPos[1]],
		[foundationPos[0],foundationPos[1]],
		[foundationPos[0]+foundationSize[0],foundationPos[1]],
		[foundationPos[0],foundationPos[1]+foundationSize[1]]
	]
	var outerWallSizes=[
		[0.1,foundationSize[1]],
		[foundationSize[0],0.1],
		[0.1,foundationSize[1]],
		[foundationSize[0],0.1]
	]
	
	
	outerWall1.place(outerWallPositions[0],0,outerWallSizes[0],wallHeight)
	outerWall2.place(outerWallPositions[1],0,outerWallSizes[1],wallHeight)
	outerWall3.place(outerWallPositions[2],0,outerWallSizes[2],wallHeight)
	outerWall4.place(outerWallPositions[3],0,outerWallSizes[3],wallHeight)
	
	#ceiling.place(foundationPos,wallHeight,foundationSize,1)
	
	var doorData=mapData["doors"]
	
	var currObj
	for i in doorData.values():
		currObj=door.instantiate()
		
		add_child(currObj)
		currObj.place(i["startCoords"],0,i["rotation"])
	
	
	var wallData=mapData["innerWalls"]
	
	for i in wallData.values():
		currObj=genericCube.instantiate()
		
		add_child(currObj)
		currObj.place(i["startCoords"],0,i["size"],wallHeight)
	
	var coverData=mapData["cover"]
	
	for i in coverData.values():
		currObj=genericCube.instantiate()
		
		add_child(currObj)
		currObj.place(i["startCoords"],0,i["size"],coverHeight)
		
	
	var playerStart=mapData["opStart"]["startCoords"]
	
	player.position=Vector3(playerStart[0],3,playerStart[1])
	player.initialWeaponSetup(player.weaponData["Bullets"])
	
	var enemyData=levelData["EnemyData"]
	var totalEnemyCount=0
	for i in enemyData:
		totalEnemyCount+=i[1]
	"""
	[
		[weapon, count],
		[weapon, count]
	]
	""" 
	var spawnerList=[]
	var spawnerData=mapData["enemy"]
	
	var obj
	for i in spawnerData.values():
		
		obj=spawner.instantiate()
		obj.position.x=i["startCoords"][0]
		obj.position.z=i["startCoords"][1]
		obj.xExtents=i["size"][0]
		obj.zExtents=i["size"][1]
		obj.enemyData=getEnemyTypes(enemyData)
		
		spawnerList.append(obj)
		add_child(obj)
	
	if len(spawnerData)>0:
		totalEnemyCount=0
		for i in enemyData:
			totalEnemyCount+=i[1]
		if totalEnemyCount>0: #put remaining enemies in last spawner
			var en=obj.enemyData
			for i in enemyData:
				for j in range(i[1]):
					en.append(i[0])
			obj.enemyData=en

		for i in spawnerList:
			i.activate()
		
	uiAnim.play("fadeOut")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_current_animation_changed(name):
	if name=="fadeOut":
		loadingBlock.visible=false
