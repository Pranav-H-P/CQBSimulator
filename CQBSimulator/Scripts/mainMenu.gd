extends CanvasLayer


@onready var main=$Main
@onready var simStart=$SimStart
@onready var mapOptions=$SimStart/HBox/MapData/MapOptions
@onready var armory=$Armory
@onready var armoryLabel=$Armory/ArmoryLabel
@onready var optionsVBox=$Armory/WeaponSetUp/VBoxContainer
@onready var uiTimer=$UITimer
@onready var gunModel=$Armory/WeaponSetUp/VBoxContainer/model/ModelOptions
@onready var fireType=$Armory/WeaponSetUp/VBoxContainer/firetype/FireOptions
@onready var playerWP1=$SimStart/HBox/PlayerData/Weapon1/Options
@onready var playerWP2=$SimStart/HBox/PlayerData/Weapon2/Options
@onready var enemyWP=$SimStart/HBox/EnemyData/AddWeapons/Options
@onready var enemyList=$SimStart/ScrollContainer/EnemyList
@onready var enemyWeaponCount=$SimStart/HBox/EnemyData/AddWeapons/LineEdit
@onready var smallTheme=preload("res://Themes/DefaultSmall.tres")
@onready var bullets1=$SimStart/HBox/PlayerData/Bullets1/LineEdit
@onready var bullets2=$SimStart/HBox/PlayerData/Bullets2/LineEdit

var enemyTypeData=[]

# Called when the node enters the scene tree for the first time.

func _ready():
	main.visible=true
	armory.visible=false
	simStart.visible=false
	
	for i in GLOBALS.loadMapList():
		mapOptions.add_item(i)
	for i in GLOBALS.loadGunList():
		playerWP1.add_item(i)
		playerWP2.add_item(i)
		enemyWP.add_item(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_pressed():
	simStart.visible=true
	main.visible=false
	


func _on_map_set_up_pressed():
	get_tree().change_scene_to_file("res://Levels/BuildingSetup.tscn")


func _on_armory_setup_pressed():
	main.visible=false
	armory.visible=true


func _on_quit_pressed():
	get_tree().quit()


func _on_SimStart_back_pressed():
	main.visible=true
	simStart.visible=false


func _on_sim_start_pressed():
	
	var playerData={}
	var allWeaponDat=GLOBALS.loadGunData()
	
	var b1=bullets1.text.strip_edges()
	var b2=bullets2.text.strip_edges()
	
	if len(b1)==0 or len(b2)==0 or !b1.is_valid_int() or !b2.is_valid_int():
		return
	
	playerData["Weapon1"]=allWeaponDat[playerWP1.get_item_text(playerWP1.get_selected_id())]
	playerData["Weapon2"]=allWeaponDat[playerWP2.get_item_text(playerWP2.get_selected_id())]
	playerData["Bullets"]=[int(b1),int(b2)]
	GLOBALS.setLevelData(mapOptions.get_item_text(mapOptions.get_selected_id()),playerData,enemyTypeData)
	get_tree().change_scene_to_file("res://Levels/TestLevel.tscn")


func _on_armory_back_pressed():
	main.visible=true
	armory.visible=false


func _on_save_weapon_pressed():
	var subBoxes=optionsVBox.get_children()
	var subSubBox
	var gunName=""
	var gunData={}
	var tempText=""
	
	
	for i in subBoxes:
		subSubBox=i.get_children()
		
		for j in subSubBox:
			if j is LineEdit:
				tempText=j.text
				tempText=tempText.strip_edges()
				
				if j.name!="Name":
					
					if len(tempText)!=0 and tempText.is_valid_float():
						
						gunData[j.name]=float(tempText)
					else:
						armoryLabel.text="Invalid "+j.name
						uiTimer.start()
						return
				else:
					if len(tempText)==0:
						armoryLabel.text="Invalid Name"
						uiTimer.start()
						return
					else:
						gunName=j.text
	
	
	
	gunData["ModelOptions"]=gunModel.get_item_text(gunModel.get_selected_id())
	gunData["FireOptions"]=fireType.get_item_text(fireType.get_selected_id())
	
	GLOBALS.storeGunData(gunName,gunData)
	armoryLabel.text="Preset Saved Successfully"
	uiTimer.start()
	playerWP1.clear()
	playerWP2.clear()
	enemyWP.clear()
	
	for i in GLOBALS.loadGunList():
		playerWP1.add_item(i)
		playerWP2.add_item(i)
		enemyWP.add_item(i)
func _on_ui_timer_timeout():
	armoryLabel.text="Armory Setup"


func _on_enemy_list_reset_pressed():
	for i in enemyList.get_children():
		i.queue_free()


func _on_add_enemy_weapons_pressed():
	var t=enemyWeaponCount.text.strip_edges()
	if len(t)!=0 and t.is_valid_int():
		
		var labl=Label.new()
		labl.text=enemyWP.get_item_text(enemyWP.get_selected_id())+" - "+t
		labl.theme=smallTheme
		enemyList.add_child(labl)
		
		enemyTypeData.append([enemyWP.get_item_text(enemyWP.get_selected_id()),int(t)])
