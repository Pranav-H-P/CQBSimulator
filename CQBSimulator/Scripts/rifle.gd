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

var posRetSpeed=30
var rotRetSpeed=10
var wNo=0

var triggerDown=false
var parentName=""


var bTotalCount=[0,0]
var bCurrCount=[0,0]
var muzzle
var model
var switchTime=1
var switching=false
var defaultPos
var defaultRotation

@onready var bullet=preload("res://Nodes/bullet.tscn")
@onready var world=get_parent().get_parent()
@onready var fireTimer=$FireTimer
@onready var gunShot=$GunShot
@onready var reloadTimer=$ReloadTimer
@onready var reloadStart=$ReloadStart
@onready var reloadEnd=$ReloadEnd
@onready var emptySound=$Empty
@onready var switchTimer=$SwitchTimer

var newBullet

# Called when the node enters the scene tree for the first time.
func _ready():
	switchTimer.wait_time=switchTime

func reload():
	if parentName=="player":
		if !switching:
			reloadTimer.start()
			reloadStart.play()
	else:
		reloadTimer.start()
		reloadStart.play()
	
	
		
func initialize(data,w=null,totalCount=null):
	switchTimer.start()
	switching=true
	$Rifle.visible=false
	$Pistol.visible=false
	
	if parentName=="player":#its the player
		wNo=w
	
	if totalCount!=null:
		bTotalCount=totalCount
	
	if data["ModelOptions"]=="Rifle":
		model=$Rifle
		muzzle=$Rifle/Muzzle
		
	else:
		model=$Pistol
		muzzle=$Pistol/Muzzle
	
	defaultPos=model.position
	defaultRotation=model.rotation
	
	
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

	reloadTimer.wait_time=reloadTime+GLOBALS.RNG.randf_range(-0.1,0.1)

func applyRecoil():
	model.position.z+=GLOBALS.RNG.randf_range(0,vRecoil/1000)
	model.position.y+=GLOBALS.RNG.randf_range(0,vRecoil/1000)
	model.rotation_degrees.y+=GLOBALS.RNG.randf_range(0,vRecoil)
	model.rotation_degrees.x+=GLOBALS.RNG.randf_range(-hRecoil,hRecoil)

func fire():
	
	if parentName=="player" :
		
		if bCurrCount[wNo]>0 and !switching:
			bCurrCount[wNo]-=1
			if pelletCount==1:
				newBullet=bullet.instantiate()
				newBullet.avoid=parentName
				world.add_child(newBullet)
				newBullet.global_position=muzzle.global_position
				newBullet.look_at(muzzle.get_collision_point(),Vector3.UP)
				newBullet.vel=projSpeed
				newBullet.mass=bulletMass
				newBullet.fired=true
			else:
				var pelletSpread=muzzle.get_collision_point()
				var dist=abs(muzzle.position.distance_to(pelletSpread))
				
				for i in range(pelletCount):
					newBullet=bullet.instantiate()
					newBullet.avoid=parentName
					world.add_child(newBullet)
					newBullet.global_position=muzzle.global_position
					pelletSpread.y+=GLOBALS.RNG.randf_range(-dist*(tan(deg_to_rad(vSpread))),dist*(tan(deg_to_rad(vSpread))))
					pelletSpread.x+=GLOBALS.RNG.randf_range(-dist*(tan(deg_to_rad(hSpread))),dist*(tan(deg_to_rad(hSpread))))
					newBullet.look_at(pelletSpread,Vector3.UP)
					newBullet.vel=projSpeed
					newBullet.mass=bulletMass
					newBullet.fired=true
					
			applyRecoil()
			
			gunShot.play()
		elif !switching:
			emptySound.play()
	else:
		if currMag>0:
			currMag-=1
			if pelletCount==1:
				newBullet=bullet.instantiate()
				newBullet.avoid=parentName
				world.add_child(newBullet)
				newBullet.global_position=muzzle.global_position
				newBullet.look_at(muzzle.get_collision_point(),Vector3.UP)
				newBullet.vel=projSpeed
				newBullet.mass=bulletMass
				newBullet.fired=true
			else:
				var pelletSpread=muzzle.get_collision_point()
				var dist=abs(muzzle.position.distance_to(pelletSpread))
				
				for i in range(pelletCount):
					newBullet=bullet.instantiate()
					newBullet.avoid=parentName
					world.add_child(newBullet)
					newBullet.global_position=muzzle.global_position
					pelletSpread.y+=GLOBALS.RNG.randf_range(-dist*(tan(deg_to_rad(vSpread))),dist*(tan(deg_to_rad(vSpread))))
					pelletSpread.x+=GLOBALS.RNG.randf_range(-dist*(tan(deg_to_rad(hSpread))),dist*(tan(deg_to_rad(hSpread))))
					newBullet.look_at(pelletSpread,Vector3.UP)
					newBullet.vel=projSpeed
					newBullet.mass=bulletMass
					newBullet.fired=true
					
			applyRecoil()
			
			gunShot.play()
		else:
			emptySound.play()
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if triggerDown and muzzle.is_colliding():
		if fireType==0:#auto
			if fireTimer.is_stopped():
				
				fire()
				fireTimer.start()
			else:
				model.position=model.position.lerp(defaultPos,delta*posRetSpeed)
				model.rotation=model.rotation.lerp(defaultRotation,delta*rotRetSpeed)
		else:
			
			fire()
			
			triggerDown=false
	else:
		fireTimer.stop()
		model.position=model.position.lerp(defaultPos,delta*posRetSpeed)
		model.rotation=model.rotation.lerp(defaultRotation,delta*rotRetSpeed)


func _on_reload_timer_timeout():
	reloadEnd.play()
	reloadTimer.wait_time=reloadTime+GLOBALS.RNG.randf_range(-0.1,0.1)
	if parentName=="player":
		var temp
		if bTotalCount[wNo]-magSize>=0:
			temp=magSize
		else:
			temp=max(0,bTotalCount[wNo])
		bTotalCount[wNo]-=temp
		bCurrCount[wNo]=temp
		print("Current Mags: ",bCurrCount)
		
	else:
		currMag=magSize


func _on_switch_timer_timeout():
	model.visible=true
	switching=false
