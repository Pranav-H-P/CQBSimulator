extends Node3D


@onready var gun = $Armature/Skeleton3D/head/Gun
@onready var animationPlayer = $AnimationPlayer
@onready var rifleModel = $Armature/Skeleton3D/righthand/Rifle_Battle_West2
@onready var pistolModel = $Armature/Skeleton3D/righthand/Pistol_Full_West2
@onready var player = $"../../Player"
@onready var alertTimer=$alertTimer
@onready var sight1=$sight1
@onready var sight2=$sight2
@onready var sight3=$sight3
@onready var sight4=$sight4
@onready var sight5=$sight5

var state = 0 # 0 is idle, 1 is player found
var alert=false
var gunName=""
# Called when the node enters the scene tree for the first time.

#rotate gun by 8 degrees down if crouching
var health = 100
var lookPos
var coll

func enemySetup(gunName):
	
	
	
	rifleModel.visible=false
	pistolModel.visible=false
	
	var gunData=GLOBALS.loadGunData()[gunName]
	gun.initialize(gunData)
	gun.parentName="enemy"
	if gunData["ModelOptions"]=="Rifle":
		rifleModel.visible=true
	else:
		pistolModel.visible=true
	
	
		
	
func hearNoise():
	alert=true
	alertTimer.start()

func _ready():
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if gun.currMag==0 and gun.reloadTimer.is_stopped():
		gun.reload()
		
	if alert:
		lookPos=player.global_position
		lookPos.y=0
		look_at(lookPos)
		if sight1.is_colliding():
			if sight1.get_collider().is_in_group("player") and gun.currMag!=0:
				gun.triggerDown=true
			else:
				gun.triggerDown=false
		else:
			gun.triggerDown=false
	else:
		gun.triggerDown=false
		
	if health<=0:
		animationPlayer.play("Armature|mixamo_com|Layer0")#death
		set_physics_process(false)
		
		
	if sight1.is_colliding():
		coll=sight1.get_collider()
		if coll.is_in_group("player"):
			hearNoise()
	if sight2.is_colliding():
		coll=sight2.get_collider()
		if coll.is_in_group("player"):
			hearNoise()
	if sight3.is_colliding():
		coll=sight3.get_collider()
		if coll.is_in_group("player"):
			hearNoise()
	if sight4.is_colliding():
		coll=sight4.get_collider()
		if coll.is_in_group("player"):
			hearNoise()
	if sight5.is_colliding():
		coll=sight5.get_collider()
		if coll.is_in_group("player"):
			hearNoise()

func _on_noise_alert_timer_timeout():
	alert=false


func _on_animation_player_current_animation_changed(name):
	if name=="Armature|mixamo_com|Layer0":
		queue_free()
