extends Node3D


@onready var gun = $Armature/Skeleton3D/BoneAttachment3D/Gun
@onready var animationPlayer = $AnimationPlayer
@onready var rifleModel = $Armature/Skeleton3D/righthand/Rifle_Battle_West2
@onready var pistolModel = $Armature/Skeleton3D/righthand/Pistol_Full_West2
@onready var player = $"../../player"

var state = 0 # 0 is idle, 1 is player found

var gunName=""
# Called when the node enters the scene tree for the first time.

#rotate gun by 8 degrees down if crouching
var health = 100


func enemySetup(gunName):
	
	
	
	rifleModel.visible=false
	pistolModel.visible=false
	
	var gunData=GLOBALS.loadGunData()[gunName]
	gun.initialize(gunData)
	if gunData["ModelOptions"]=="Rifle":
		rifleModel.visible=true
	else:
		pistolModel.visible=true
	print(gunName)
	
func _ready():
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass
