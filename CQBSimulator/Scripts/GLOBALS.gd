extends Node

var RNG
var currMapName
var currPlayerData
var currEnemyData

var mapPath="user://mapData.save"
var trainingSavePath="user://trainingData.save"
var weaponPath="user://weapons.save"
var levelId

"""trainingData
{
	mapname#EnemyCounts:{
		"0":[
			[weaponList],
			[PositionArr]
		],
		"1":....
	}
}


"""

var currEnemyLoadName

var currRound=1

func saveJson(content,path):
	
	var file = FileAccess.open(path,FileAccess.WRITE)
	
	file.store_line(JSON.stringify(content))
	file.close()
	

func readJson(path):
	if not FileAccess.file_exists(path):
		return {}
	var file = FileAccess.open(path,FileAccess.READ)
	var json_string = file.get_line()
	var json=JSON.new()
	var error := json.parse(json_string)
	if error:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return {}
	
	return json.data

func loadMapData(mapName):
	var mapDat=readJson(mapPath)
	return mapDat[mapName]

func loadMapList():
	var mapDat=readJson(mapPath)
	return mapDat.keys()

func loadGunList():
	var gunDat=readJson(weaponPath)
	
	return gunDat.keys()

func appendMapData(mapName,data):
	var mapDat=readJson(mapPath)
	mapDat[mapName]=data
	saveJson(mapDat,mapPath)

func setLevelData(mapName,playerData,enemyData):
	
	levelId=mapName
	for i in enemyData:
		levelId+="#"+i[0]+"-"+str(i[1])
	
	currMapName=mapName
	currPlayerData=playerData
	currEnemyData=enemyData

func loadGunData():
	var gunDat=readJson(weaponPath)
	return gunDat

func storeGunData(gunName,data):
	var gunDat=loadGunData()
	gunDat[gunName]=data
	
	saveJson(gunDat,weaponPath)

func getCurrLevelData():
	return {
		"MapData":loadMapData(currMapName),
		"PlayerData":currPlayerData.duplicate(true),
		"EnemyData":currEnemyData.duplicate(true)
		}
		
func loadTrainingData():
	var trainingDat=readJson(trainingSavePath)
	return trainingDat
	
func storeTrainingData(dat):
	var trainingDat = loadTrainingData()
	trainingDat[levelId]=dat
	saveJson(trainingDat,trainingSavePath)
	
	
func getSavedEnemyTypes(spawnerId):
	
	var trainingDat = loadTrainingData()
	
	return trainingDat[levelId][spawnerId][0]
	
func getLastPositionArray(spawnerId):
	
	var trainingDat = loadTrainingData()
	
	return trainingDat[levelId][spawnerId][1].duplicate(true)

func _ready():
	RNG= RandomNumberGenerator.new()
	RNG.randomize()
