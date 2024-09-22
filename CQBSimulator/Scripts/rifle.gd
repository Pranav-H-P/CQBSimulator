extends Node3D


var fireType=0
var fireRate=0
var hRecoil=0
var vRecoil=0
var bulletMass=0
var magSize=0
var currMag=0
var hSpread=0
var vSpread=0
var pelletCount=0
var projSpeed=0
var reloadTime=1
var volume=1

var triggerDown=false
var parentName=""

@onready var bullet=preload("res://Nodes/bullet.tscn")
var muzzle
var model

@onready var world=get_parent().get_parent()
@onready var fireTimer=$FireTimer
@onready var gunShot=$GunShot

var newBullet

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reload(left):
	currMag=max(0,(left-magSize))

func initialize(data):
	
	$Rifle.visible=false
	$Pistol.visible=false
	
	if data["ModelOptions"]=="Rifle":
		model=$Rifle
		muzzle=$Rifle/Muzzle
		
	else:
		model=$Pistol
		muzzle=$Pistol/Muzzle
	
	model.visible=true
	
	if data["FireOptions"]=="Automatic":
		fireType=0
	else:
		fireType=1
	
	fireRate=data["FireRate"]
	
	fireTimer.wait_time=60/fireRate
	
	hRecoil=data["HRecoil"]
	vRecoil=data["VRecoil"]
	bulletMass=data["Mass"]
	magSize=data["Mag"]
	
	hSpread=data["HSpread"]
	vSpread=data["VSpread"]
	pelletCount=data["PelletCount"]
	projSpeed=data["ProjSpeed"]
	reloadTime=data["ReloadTime"]
	volume=data["Volume"]
	print(fireTimer.wait_time)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if triggerDown and muzzle.is_colliding():
		if fireType==0:#auto
			if fireTimer.is_stopped():
				
				newBullet=bullet.instantiate()
				newBullet.avoid=parentName
				world.add_child(newBullet)
				newBullet.global_position=muzzle.global_position
				newBullet.look_at(muzzle.get_collision_point(),Vector3.UP)
				
				
				newBullet.vel=projSpeed
				newBullet.mass=bulletMass
				newBullet.fired=true
				fireTimer.start()
				gunShot.play()
		else:
			
			gunShot.play()
			newBullet=bullet.instantiate()
			newBullet.avoid=parentName
			world.add_child(newBullet)
			newBullet.global_position=muzzle.global_position
			newBullet.look_at(muzzle.get_collision_point(),Vector3.UP)
			
			
			newBullet.vel=projSpeed
			newBullet.mass=bulletMass
			newBullet.fired=true
			triggerDown=false
	else:
		fireTimer.stop()
