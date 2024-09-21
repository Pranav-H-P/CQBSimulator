extends CanvasLayer


@onready var main=$Main
@onready var simStart=$SimStart
@onready var mapOptions=$SimStart/HBox/MapData/MapOptions

# Called when the node enters the scene tree for the first time.

func _ready():
	main.visible=true
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
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()


func _on_SimStart_back_pressed():
	main.visible=true
	simStart.visible=false


func _on_sim_start_pressed():
	GLOBALS.setLevelData(mapOptions.get_item_text(mapOptions.get_selected_id()))
	get_tree().change_scene_to_file("res://Levels/TestLevel.tscn")
