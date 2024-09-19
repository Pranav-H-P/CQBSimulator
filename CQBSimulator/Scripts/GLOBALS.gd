extends Node



var currMap={}
var mapPath="user://mapData.save"

var weaponPath="users://weapons.save"
var currLoadout={}
var currEnemyLoad={}

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

func _ready():
	pass # Replace with function body.
