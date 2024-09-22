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

# Called when the node enters the scene tree for the first time.

func _ready():
	main.visible=true
	armory.visible=false
	simStart.visible=false
	
	for i in GLOBALS.loadMapList():
		mapOptions.add_item(i)

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
	GLOBALS.setLevelData(mapOptions.get_item_text(mapOptions.get_selected_id()))
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
	
func _on_ui_timer_timeout():
	armoryLabel.text="Armory Setup"
